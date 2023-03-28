//
//  WithdrawalReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class WithdrawalReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case backButtonDidTap
        case agreeCheckBoxDidTap
        case withdrawalButtonDidTap
    }
    
    enum Mutation {
        case setNickname(String)
        case toggleAgree
    }
    
    struct State {
        var nickname = ""
        var isAgree = false
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return provider.userService.mypageInformation().data().decode(type: MyPageInformationResponse.self, decoder: JSONDecoder())
                .map { .setNickname($0.result.nickname) }
            
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .agreeCheckBoxDidTap:
            return .just(.toggleAgree)
            
        case .withdrawalButtonDidTap:
            switch provider.appSettingService.lastLoginType {
            case .apple:
                provider.appleLoginService.login(with: [.fullName, .email]) { loginResult, error in
                    if let error = error {
                        print(error)
                    }
                    guard let code = loginResult?.authorizationCode,
                          let oauthToken = String(data: code, encoding: .utf8) else { return }
                    self.provider.userService.withdrawAppleUser(authorizationCode: oauthToken).data()
                        .subscribe(onNext: { [weak self] _ in
                            self?.provider.appSettingService.logout()
                            DispatchQueue.main.async {
                                self?.steps.accept(AppStep.userIsLoggedOut)
                            }
                        }).disposed(by: self.disposeBag)
                }
                return .empty()
            default:
                return provider.userService.withdrawUser()
                    .data().flatMap { [weak self] _ in
                        self?.provider.appSettingService.logout()
                        self?.steps.accept(AppStep.userIsLoggedOut)
                        return Observable<Mutation>.empty()
                    }
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setNickname(let nickname):
            state.nickname = nickname
            
        case .toggleAgree:
            state.isAgree.toggle()
        }
        
        return state
    }
}
