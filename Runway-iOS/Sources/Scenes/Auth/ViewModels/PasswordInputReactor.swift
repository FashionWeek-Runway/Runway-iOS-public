//
//  PasswordInputReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/16.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit
import RxFlow

final class PasswordInputReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case passwordFieldInput(String)
        case passwordValidationFieldInput(String)
        case nextButtonDidTap
    }
    
    enum Mutation {
        case setPassword(String)
        case setValidationPassword(String)
    }
    
    struct State{
        var password: String? = nil
        var validationPassword: String? = nil
        
        var isPasswordContainEnglish: Bool = false
        var isPasswordContainNumber: Bool = false
        var isPasswordLengthIsSuit: Bool = false
        var IsPasswordEqual: Bool = false
        var isNextEnable: Bool = false
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
        case .passwordValidationFieldInput(let password):
            return .just(.setValidationPassword(password))
            
        case .nextButtonDidTap:
            guard let password = currentState.password else { return .empty() }
            provider.signUpService.signUpAsPhoneData?.password = password
            steps.accept(AppStep.policyAgreementIsRequired)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPassword(let password):
            state.password = password
            state.isPasswordContainEnglish = checkStringContainsEnglishExceptNumber(password)
            state.isPasswordContainNumber = checkStringContainsNumberExceptEnglish(password)
            state.isPasswordLengthIsSuit = 8...16 ~= password.count
        case .setValidationPassword(let password):
            state.validationPassword = password
            if let currentPassword = state.password,
                password == state.password
                && !password.isEmpty
                && !currentPassword.isEmpty {
                state.IsPasswordEqual = true
            } else {
                state.IsPasswordEqual = false
            }
            if state.IsPasswordEqual
                && state.isPasswordContainNumber
                && state.isPasswordContainEnglish
                && state.isPasswordLengthIsSuit {
                state.isNextEnable = true
            } else {
                state.isNextEnable = false
            }
        }
        return state
    }
    
    private func checkStringContainsEnglishExceptNumber(_ string: String) -> Bool {
        let pattern = "^[a-zA-Z0-9]+$" // regular expression pattern to match English letters only
        
        if string.range(of: pattern, options: .regularExpression) != nil {
            return true
        } else {
            return false
        }
    }
    
    private func checkStringContainsNumberExceptEnglish(_ string: String) -> Bool {
        let pattern = "[0-9]" // regular expression pattern to match any digit character
        
        if string.range(of: pattern, options: .regularExpression) != nil {
            return true
        } else {
            return false
        }
    }
    
}
