//
//  PolicyAgreementReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class PolicyAgreementReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case allAgreeButtonDidTap
        case usagePolicyAgreeButtonDidTap
        case privacyPolicyAgreeButtonDidTap
        case locationPolicyAgreeButtonDidTap
        case marketingPolicyAgreeButtonDidTap
        
        case usagePolicyDetailButtonDidTap
        case privacyPolicyDetailButtonDidTap
        case locationPolicyDetailButtonDidTap
        case marketingDetailButtonDidTap
        case nextButtonDidTap
    }
    
    enum Mutation {
        case setAllAgree
        case setUsagePolicyAgree
        case setPrivacyPolicyAgree
        case setLocationPolicyAgree
        case setMarketingPolicyAgree
    }
    
    struct State {
        var isAllAgreePolicy: Bool = false
        var isAgreeUsagePolicy: Bool = false
        var isAgreePrivacyPolicy: Bool = false
        var isAgreeLocationPolicy: Bool = false
        var isAgreeMarketingPolicy: Bool = false
        
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
        case .allAgreeButtonDidTap:
            return .just(.setAllAgree)
        case .usagePolicyAgreeButtonDidTap:
            return .just(.setUsagePolicyAgree)
        case .privacyPolicyAgreeButtonDidTap:
            return .just(.setPrivacyPolicyAgree)
        case .locationPolicyAgreeButtonDidTap:
            return .just(.setLocationPolicyAgree)
        case .marketingPolicyAgreeButtonDidTap:
            return .just(.setMarketingPolicyAgree)
            
            
        case .usagePolicyDetailButtonDidTap:
            steps.accept(AppStep.usagePolicyDetailNeedToShow)
            return .empty()
        case .privacyPolicyDetailButtonDidTap:
            steps.accept(AppStep.privacyPolicyDetailNeedToShow)
            return .empty()
        case .locationPolicyDetailButtonDidTap:
            steps.accept(AppStep.locationPolicyDetailNeedToShow)
            return .empty()
        case .marketingDetailButtonDidTap:
            steps.accept(AppStep.marketingPolicyDetailNeedToShow)
            return .empty()
            
        case .nextButtonDidTap:
            steps.accept(AppStep.profileSettingIsRequired)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setAllAgree:
            if state.isAllAgreePolicy == true {
                state.isAllAgreePolicy = false
                state.isAgreeUsagePolicy = false
                state.isAgreePrivacyPolicy = false
                state.isAgreeLocationPolicy = false
                state.isAgreeMarketingPolicy = false
            } else {
                state.isAllAgreePolicy = true
                state.isAgreeUsagePolicy = true
                state.isAgreePrivacyPolicy = true
                state.isAgreeLocationPolicy = true
                state.isAgreeMarketingPolicy = true
            }
        case .setUsagePolicyAgree:
            state.isAgreeUsagePolicy.toggle()
            if state.isAgreeUsagePolicy == false {
                state.isAllAgreePolicy = false
            }
        case .setPrivacyPolicyAgree:
            state.isAgreePrivacyPolicy.toggle()
            if state.isAgreePrivacyPolicy == false {
                state.isAllAgreePolicy = false
            }
        case .setLocationPolicyAgree:
            state.isAgreeLocationPolicy.toggle()
            if state.isAgreeLocationPolicy == false {
                state.isAllAgreePolicy = false
            }
        case .setMarketingPolicyAgree:
            state.isAgreeMarketingPolicy.toggle()
            if state.isAgreeMarketingPolicy == false {
                state.isAllAgreePolicy = false
            }
        }
        
        if state.isAgreeUsagePolicy
            && state.isAgreePrivacyPolicy
            && state.isAgreeLocationPolicy {
            state.isNextEnable = true
        } else {
            state.isNextEnable = false
        }
        return state
    }
    
}

