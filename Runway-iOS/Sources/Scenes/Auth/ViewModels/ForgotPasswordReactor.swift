//
//  ForgotPasswordReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class ForgotPasswordReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case enterMobileCarrier(String)
        case enterPhoneNumber(String?)
        case requestButtonDidTap
    }
    
    enum Mutation {
        case setMobileCarrier(String)
        case setPhoneNumber(String)
    }
    
    struct State{
        var mobileCarrier: String? = nil
        var phoneNumber: String? = nil
        
        var isRequestEnable: Bool = false
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .enterPhoneNumber(let number):
            return  .just(.setPhoneNumber(String.limitedLengthString(number ?? "", length: 11)))
        case .enterMobileCarrier(let carrier):
            return  .just(.setMobileCarrier(carrier))
        case .requestButtonDidTap:
            guard let phoneNumber = currentState.phoneNumber else { return .empty() }
            steps.accept(AppStep.forgotPasswordCertificationIsRequired(phoneNumber))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPhoneNumber(let string):
            state.phoneNumber = string
        case .setMobileCarrier(let carrier):
            state.mobileCarrier = carrier
        }
        if state.phoneNumber?.count ?? 0 > 8 && state.mobileCarrier != nil {
            state.isRequestEnable = true
        } else {
            state.isRequestEnable = false
        }
        return state
    }
    
}
