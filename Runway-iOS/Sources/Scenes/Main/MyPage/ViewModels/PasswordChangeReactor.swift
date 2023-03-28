//
//  PasswordChangeReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit
import RxFlow

final class PasswordChangeReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case passwordFieldInput(String)
        case nextButtonDidTap
    }
    
    enum Mutation {
        case setPassword(String)
        case setIsSamePassword(Bool)
    }
    
    struct State{
        var password: String? = nil

        var isNextEnable: Bool = false
        var isNotSamePassword: Bool = false
    }
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .passwordFieldInput(let password):
            return .just(.setPassword(password))
            
        case .nextButtonDidTap:
            guard let enteredPassword = currentState.password else { return .empty() }
            return provider.userService.checkOriginalPassword(password: enteredPassword)
                .data().decode(type: BaseResponse.self, decoder: JSONDecoder())
                .flatMap { [weak self] responseData -> Observable<Mutation> in
                    if responseData.isSuccess {
                        self?.steps.accept(AppStep.newPasswordInput)
                        return .empty()
                    } else {
                        return .just(.setIsSamePassword(true))
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.isNotSamePassword = false
        switch mutation {
        case .setPassword(let password):
            state.password = password
            
        case .setIsSamePassword(let bool):
            state.isNotSamePassword = bool
        }
        state.isNextEnable = state.password?.isEmpty != true
        return state
    }
}
