//
//  NewPasswordInputReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/16.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit
import RxFlow

final class NewPasswordInputReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case alertConfirmButtonDidTap
        case passwordFieldInput(String)
        case passwordValidationFieldInput(String)
        case nextButtonDidTap
    }
    
    enum Mutation {
        case setPassword(String)
        case setValidationPassword(String)
        case showChangedAlert
    }
    
    struct State{
        var password: String? = nil
        var validationPassword: String? = nil
        var shouldShowAlert = false
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
    
    let phoneNumber: String
    
    init(provider: ServiceProviderType, phoneNumber: String) {
        self.provider = provider
        self.initialState = State()
        self.phoneNumber = phoneNumber
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .alertConfirmButtonDidTap:
            steps.accept(AppStep.dismiss)
            steps.accept(AppStep.userChangedPassword)
            return .empty()
        case .passwordFieldInput(let password):
            return .just(.setPassword(password))
        case .passwordValidationFieldInput(let password):
            return .just(.setValidationPassword(password))
            
        case .nextButtonDidTap:
            guard let password = currentState.password else { return .empty() }
            
            return provider.signUpService.setUserPassword(phoneNumber: phoneNumber, password: password).validate(statusCode: 200...299).map { _ in Mutation.showChangedAlert }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.shouldShowAlert = false
        switch mutation {
        case .setPassword(let password):
            state.password = password
            state.isPasswordContainEnglish = checkStringContainsEnglish(password)
            state.isPasswordContainNumber = checkStringContainsNumber(password)
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
        case .showChangedAlert:
            state.shouldShowAlert = true
        }
        return state
    }
    
    private func checkStringContainsEnglish(_ string: String) -> Bool {
        let pattern = "[a-zA-Z]" // regular expression pattern to match English letters only
        
        if string.range(of: pattern, options: .regularExpression) != nil {
            return true
        } else {
            return false
        }
    }
    
    private func checkStringContainsNumber(_ string: String) -> Bool {
        let pattern = "[0-9]" // regular expression pattern to match any digit character
        
        if string.range(of: pattern, options: .regularExpression) != nil {
            return true
        } else {
            return false
        }
    }
    
}
