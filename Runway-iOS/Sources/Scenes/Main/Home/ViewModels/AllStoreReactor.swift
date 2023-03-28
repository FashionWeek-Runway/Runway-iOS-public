//
//  AllStoreReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/08.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class AllStoreReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewWillAppear
        case backButtonDidTap
        case selectStoreCell(Int)
        case bookmarkButtonDidTap(Int)
    }
    
    enum Mutation {
        case setStoreDatas([HomeStoreResponseResult])
    }
    
    struct State {
        var storeDatas: [HomeStoreResponseResult] = []
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
        case .viewWillAppear:
            return provider.homeService.home(type: .all).data().decode(type: HomeStoreResponse.self, decoder: JSONDecoder())
                .map { Mutation.setStoreDatas($0.result) }
            
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .selectStoreCell(let storeId):
            steps.accept(AppStep.showRoomDetail(storeId))
            return .empty()
            
        case .bookmarkButtonDidTap(let storeId):
            return provider.showRoomService.storeBookmark(storeId: storeId)
                .flatMap { response -> Observable<Mutation> in
                    return .empty()
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setStoreDatas(let results):
            state.storeDatas = results
        }
        return state
    }
}
