//
//  EditReviewReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class EditReviewReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case registerButtonDidTap(Data?)
    }
    
    enum Mutation {
        case setLoading(Bool)
    }
    
    struct State {
        var reviewImageData: Data
        var isLoading: Bool = false
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    let storeId: Int
    
    // MARK: - initializer
    init(provider: ServiceProviderType, storeId: Int, reviewImageData: Data) {
        self.provider = provider
        self.initialState = State(reviewImageData: reviewImageData)
        self.storeId = storeId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .registerButtonDidTap(let imageData):
            guard let imageData = imageData else { return .empty() }
            
            return Observable.concat([
                .just(.setLoading(true)),
                
                provider.showRoomService.storeReview(storeId: storeId, imageData: imageData)
                    .flatMap { $0.rx.data() }.decode(type: BaseResponse.self, decoder: JSONDecoder())
                    .map { _ in
                        self.steps.accept(AppStep.back(animated: false))
                        return .setLoading(false)
                    }
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        
        return state
    }
}

