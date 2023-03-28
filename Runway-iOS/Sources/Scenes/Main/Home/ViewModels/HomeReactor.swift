//
//  HomeReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class HomeReactor: Reactor, Stepper {
    // MARK: - Events

    
    enum Action {
        case viewWillAppear
        case categorySelectButtonDidTap
        case showAllContentButtonDidTap
        case pagerBookmarkButtonDidTap(Int)
        case pagerCellDidTap(Int)
        case userReviewCollectionViewReachesEnd
        case userReviewCellDidTap(Int)
    }
    
    enum Mutation {
        case setPagerData([HomeStoreResponseResult])
        case setUserReview(HomeReviewResponseResult)
        case appendUserReview(HomeReviewResponseResult)
        case setUserName(String)
    }
    
    struct State {
        var nickname: String? = nil
        var pagerData: [HomeStoreResponseResult] = []
        
        var userReview: [HomeReviewResponseResultContent] = []
        var userReviewIsLast: Bool = false
        var userReviewPage: Int = 0
        
        
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
            return Observable.concat([
                provider.homeService.home(type: .home).data().decode(type: HomeStoreResponse.self, decoder: JSONDecoder()).map {
                    return Mutation.setPagerData($0.result)
                },
                provider.homeService.review(page: 0, size: 30).data().decode(type: HomeReviewResponse.self, decoder: JSONDecoder()).map {
                    return Mutation.setUserReview($0.result)
                },
                provider.userService.mypageInformation().data().decode(type: MyPageInformationResponse.self, decoder: JSONDecoder()).map {
                    return Mutation.setUserName($0.result.nickname)
                }
            ])
            
        case .showAllContentButtonDidTap:
            steps.accept(AppStep.showAllStore)
            return .empty()
            
        case .pagerBookmarkButtonDidTap(let storeId):
            return provider.showRoomService.storeBookmark(storeId: storeId)
                .flatMap { response -> Observable<Mutation> in
                    return .empty()
                }
            
        case .pagerCellDidTap(let storeId):
            steps.accept(AppStep.showRoomDetail(storeId))
            return .empty()
            
        case .categorySelectButtonDidTap:
            guard let nickname = currentState.nickname else { return .empty()}
            steps.accept(AppStep.categorySelect(nickname))
            return .empty()
            
        case .userReviewCollectionViewReachesEnd:
            return currentState.userReviewIsLast ? .empty() : provider.homeService.review(page: currentState.userReviewPage, size: 10).data().decode(type: HomeReviewResponse.self, decoder: JSONDecoder()).map {
                return Mutation.appendUserReview($0.result)
            }
            
        case .userReviewCellDidTap(let reviewId):
            steps.accept(AppStep.userReviewReels(Id: reviewId, mode: .home))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPagerData(let results):
            state.pagerData = results + [HomeStoreResponseResult(isBookmarked: false,
                                                                 imageURL: "",
                                                                 storeID: 0,
                                                                 storeName: "",
                                                                 regionInfo: "",
                                                                 categoryList: [],
                                                                 bookmarkCount: 0,
                                                                 cellType: .showMoreShop)]
        case .setUserReview(let result):
            state.userReviewPage = 0
            state.userReview = result.contents
            state.userReviewIsLast = result.isLast
            if !result.isLast {
                state.userReviewPage += 1
            }
        case .appendUserReview(let result):
            state.userReview.append(contentsOf: result.contents)
            state.userReviewIsLast = result.isLast
            if !result.isLast {
                state.userReviewPage += 1
            }
            
        case .setUserName(let username):
            state.nickname = username
        }
        
        return state
    }
}
