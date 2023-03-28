//
//  ReviewReportingReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/06.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class ReviewReportingReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case spamButtonDidTap
        case inappropreateButtonDidTap
        case harmfulButtonDidTap
        case abuseButtonDidTap
        case lieButtonDidTap
        case etcButtonDidTap
        
        case enterOpinion(String?)
        case reportButtonDidTap
    }
    
    enum Mutation {
        case setReportingReason(Int)
        case setOpinion(String)
        case setReportButtonIsEnable(Bool)
    }
    
    struct State {
        var reportingReason: Int? = nil
        var reportButtonIsEnable = false
        var opinion: String = ""
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
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .spamButtonDidTap:
            return Observable.concat([
                .just(.setReportingReason(1)),
                .just(.setReportButtonIsEnable(true))
            ])
        case .inappropreateButtonDidTap:
            return Observable.concat([
                .just(.setReportingReason(2)),
                .just(.setReportButtonIsEnable(true))
            ])
        case .harmfulButtonDidTap:
            return Observable.concat([
                .just(.setReportingReason(3)),
                .just(.setReportButtonIsEnable(true))
            ])
        case .abuseButtonDidTap:
            return Observable.concat([
                .just(.setReportingReason(4)),
                .just(.setReportButtonIsEnable(true))
            ])
        case .lieButtonDidTap:
            return Observable.concat([
                .just(.setReportingReason(5)),
                .just(.setReportButtonIsEnable(true))
            ])
        case .etcButtonDidTap:
            return Observable.concat([
                .just(.setReportingReason(6)),
                .just(.setReportButtonIsEnable(true))
            ])
        case .enterOpinion(let text):
            return .just(.setOpinion(text ?? ""))
        case .reportButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setReportingReason(let reasonNumber):
            state.reportingReason = reasonNumber
        case .setOpinion(let text):
            state.opinion = String.limitedLengthString(text, length: 100)
        case .setReportButtonIsEnable(let bool):
            state.reportButtonIsEnable = bool
        }
        
        return state
    }
}

