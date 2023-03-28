//
//  ShowRoomDetailReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class ShowRoomDetailReactor: Reactor, Stepper {
    // MARK: - Events

    enum Action {
        case viewWillAppear
        case backButtonDidTap
        case bookmarkButtonDidTap
        case userReviewScrollReachesBottom
        case reviewCellDidTap(Int)
        case pickingReviewImage(Data?)
    }

    enum Mutation {
        case setStoreDetailInfo(ShowRoomDetailResponseResult)
        case setStoreReview(UserReviewResponseResult)
        case setStoreReviewAppend(UserReviewResponseResult)
        case setIsBookMark(Bool)
        case setBlogReviews([ShowRoomBlogsResponseResult])
    }

    struct State {
        var mainImageURL: String? = nil
        var title: String = ""
        var categories: [String] = []
        var address: String = ""
        var timeInfo: String = ""
        var phoneNumber: String = ""
        var instagramID: String = ""
        var webSiteLink: String = ""
        var isBookmark: Bool = false
        
        var userReviewImages: [(Int, String)] = []
        
        var blogReviews: [ShowRoomBlogsResponseResult] = []
        
        var userReviewPage: Int = 0
        var userReviewIsLast: Bool = false
    }

    // MARK: - Properties

    var steps = PublishRelay<Step>()

    let initialState: State
    let provider: ServiceProviderType

    private let disposeBag = DisposeBag()

    let storeId: Int

    // MARK: - initializer
    init(provider: ServiceProviderType, storeId: Int) {
        self.provider = provider
        self.initialState = State()
        self.storeId = storeId
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return Observable.concat([
                provider.showRoomService.storeDetail(storeId: storeId)
                    .data().decode(type: ShowRoomDetailResponse.self, decoder: JSONDecoder())
                    .flatMap { [weak self] data -> Observable<Mutation> in
                        guard let self else { return .empty() }
                        
                        return self.provider.showRoomService.storeBlogs(storeId: self.storeId, storeName: data.result.storeName)
                            .data().decode(type: ShowRoomBlogsResponse.self, decoder: JSONDecoder())
                            .flatMap { blogData -> Observable<Mutation> in
                                Observable.concat([
                                    .just(.setBlogReviews(blogData.result)),
                                    .just(.setStoreDetailInfo(data.result))
                                ])
                            }
                    },
                
                provider.showRoomService.storeReview(storeId: storeId, page: 0, size: 5)
                    .data().decode(type: UserReviewResponse.self, decoder: JSONDecoder())
                    .map { Mutation.setStoreReview($0.result)}
            ])
            
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .bookmarkButtonDidTap:
            provider.showRoomService.storeBookmark(storeId: storeId)
                .subscribe(onNext: { [weak self] _ in
                }).disposed(by: disposeBag)
            return .just(.setIsBookMark(!currentState.isBookmark))
            
        case .userReviewScrollReachesBottom:
            if currentState.userReviewIsLast {
                return .empty()
            } else {
                return provider.showRoomService.storeReview(storeId: storeId, page: currentState.userReviewPage, size: 5)
                    .data().decode(type: UserReviewResponse.self, decoder: JSONDecoder())
                    .map { Mutation.setStoreReviewAppend($0.result)}
            }
            
        case .reviewCellDidTap(let reviewId):
            steps.accept(AppStep.userReviewReels(Id: reviewId, mode: .store))
            return .empty()
            
        case .pickingReviewImage(let imageData):
            guard let imageData else { return .empty() }
            steps.accept(AppStep.editReviewImage(storeId, imageData))
            return .empty()
        }
        

    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state

        switch mutation {
        case .setStoreDetailInfo(let result):
            state.mainImageURL = result.imageURLList.first
            state.title = result.storeName
            state.categories = result.category
            state.address = result.address
            state.timeInfo = result.storeTime
            state.phoneNumber = result.storePhone
            state.instagramID = result.instagram
            state.webSiteLink = result.webSite
            state.isBookmark = result.bookmark
        case .setIsBookMark(let isSelected):
            state.isBookmark = isSelected
            
        case .setStoreReview(let result):
            state.userReviewPage = 0
            state.userReviewImages = result.contents.map { ($0.reviewID, $0.imgURL) }
            state.userReviewIsLast = result.isLast
            if !result.isLast {
                state.userReviewPage += 1
            }
            
        case .setStoreReviewAppend(let result):
            state.userReviewImages.append(contentsOf: result.contents.map { ($0.reviewID, $0.imgURL) })
            state.userReviewIsLast = result.isLast
            if !result.isLast {
                state.userReviewPage += 1
            }
            
        case .setBlogReviews(let results):
            state.blogReviews = results
        }
        
        return state
    }
}
