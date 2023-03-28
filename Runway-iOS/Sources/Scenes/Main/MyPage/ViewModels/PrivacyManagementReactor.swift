//
//  PrivacyManagementReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKUser
import RxKakaoSDKAuth

import Alamofire


final class PrivacyManagementReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case backButtonDidtap
        case kakaoConnectSwitch(Bool)
        case appleConnectSwitch(Bool)
        case passwordChangeButtonDidTap
        case withdrawalButtonDidTap
    }
    
    enum Mutation {
        case setUserPrivacy(UserPrivacyResponseResult)
        case setKakaoConnect(Bool)
        case setAppleConnect(Bool)
    }
    
    struct State {
        var phoneNumber: String? = nil
        var iskakaoConnected: Bool = false
        var isAppleConnected: Bool = false
        var isSocial: Bool = false
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
            return provider.userService.privacyInformation().data().decode(type: UserPrivacyResponse.self, decoder: JSONDecoder())
                .map { .setUserPrivacy($0.result) }
            
        case .kakaoConnectSwitch(let isOn):
            if isOn {
                if UserApi.isKakaoTalkLoginAvailable() {
                    return UserApi.shared.rx.loginWithKakaoTalk()
                        .flatMap { [weak self] token -> Observable<Mutation> in
                            return self?.provider.userService.linkWithKakao(socialToken: token.accessToken)
                                .validate(statusCode: 200...299)
                                .map { _ in .setKakaoConnect(true) } ?? .empty()
                        }
                } else {
                    return UserApi.shared.rx.loginWithKakaoAccount()
                        .flatMap { [weak self] token -> Observable<Mutation> in
                            return self?.provider.userService.linkWithKakao(socialToken: token.accessToken).data()
                                .map { _ in .setKakaoConnect(true) } ?? .empty()
                        }
                }
            } else {
                return provider.userService.unlinkWithKakao()
                    .map { _ in .setKakaoConnect(false) }
            }
            
        case .appleConnectSwitch(let isOn):
            if isOn {
                provider.appleLoginService.login(with: [.fullName, .email]) { loginResult, error in
                    if let error = error {
                        print(error)
                    }
                    
                    guard let identityToken = loginResult?.identityToken,
                          let oauthToken = String(data: identityToken, encoding: .utf8) else { return }
                    self.provider.userService.linkWithApple(socialToken: oauthToken).data()
                        .subscribe(onNext: { [weak self] in
                            print($0)
                        }).disposed(by: self.disposeBag)
                }
                return .just(.setAppleConnect(true))
            } else {
                provider.appleLoginService.login(with: [.fullName, .email]) { loginResult, error in
                    if let error = error {
                        print(error)
                    }
                    
                    guard let authorizationCode = loginResult?.authorizationCode,
                          let code = String(data: authorizationCode, encoding: .utf8) else { return }
                    self.provider.userService.unlinkWithApple(authorizationCode: code).data()
                        .subscribe(onNext: { [weak self] in
                            print($0)
                        }).disposed(by: self.disposeBag)
                }
                UIWindow.makeToastAnimation(message: "애플 계정 연결이 해제되었습니다.", .bottom, 20.0)
                return .just(.setAppleConnect(false))
            }
            
        case .passwordChangeButtonDidTap:
            steps.accept(AppStep.passwordChange)
            return .empty()
            
        case .backButtonDidtap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .withdrawalButtonDidTap:
            steps.accept(AppStep.withdrawalStep)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setUserPrivacy(let result):
            state.phoneNumber = result.phone
            state.iskakaoConnected = result.kakao
            state.isAppleConnected = result.apple
            state.isSocial = result.social
            
        case .setKakaoConnect(let bool):
            state.iskakaoConnected = bool
            
        case .setAppleConnect(let bool):
            state.isAppleConnected = bool
        }
        
        return state
    }
}
