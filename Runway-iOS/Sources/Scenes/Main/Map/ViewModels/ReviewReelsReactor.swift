//
//  ReviewReelsReactor.swift
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


final class ReviewReelsReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case exitButtonDidTap
        case swipeNextReview
        case swipePreviousReview
        case bookmarkButtonDidTap(Int)
        case showRoomButtonDidTap(Int)
        
        case removeButtonDidTap(Int)
        case reportButtonDidTap(Int)
    }
    
    enum Mutation {
        case setReviewData(ReviewDetailResponseResult)
        case appendReviewData(ReviewDetailResponseResult)
        case insertFrontReviewData(ReviewDetailResponseResult)
    }
    
    struct State {
        var previousReviewId: Int? = nil
        var nextReviewId: Int? = nil
        
        var currentShowingReviewId: Int? = nil
        var reviewData: [ReviewDetailResponseResult] = []
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    let intialReviewId: Int
    
    enum TraverseMode {
        case home
        case store
        case myReview
        case bookmarkedReview
    }
    
    let traverseMode: TraverseMode
    
    // MARK: - initializer
    init(provider: ServiceProviderType, intialReviewId reviewId: Int, mode: TraverseMode = .store) {
        self.provider = provider
        self.initialState = State()
        self.intialReviewId = reviewId
        self.traverseMode = mode
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            switch traverseMode {
            case .home:
                return provider.homeService.reviewDetail(reviewId: intialReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .setReviewData($0.result) }
            case .store:
                return provider.showRoomService.reviewDetail(reviewId: intialReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .setReviewData($0.result) }
                
            case .myReview:
                return provider.userService.myReviewDetail(reviewId: intialReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .setReviewData($0.result) }
                
            case .bookmarkedReview:
                return provider.userService.bookmarkReviewDetail(reviewId: intialReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .setReviewData($0.result) }
            }
        
        case .swipeNextReview:
            guard let nextReviewId = currentState.nextReviewId else {
                steps.accept(AppStep.back(animated: true))
                return .empty()
            }
            
            switch traverseMode {
            case .home:
                return provider.homeService.reviewDetail(reviewId: nextReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .appendReviewData($0.result) }
            case .store:
                return provider.showRoomService.reviewDetail(reviewId: nextReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .appendReviewData($0.result) }
                
            case .myReview:
                return provider.userService.myReviewDetail(reviewId: nextReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .appendReviewData($0.result) }
            case .bookmarkedReview:
                return provider.userService.bookmarkReviewDetail(reviewId: nextReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .appendReviewData($0.result) }
            }
            
        case .swipePreviousReview:
            guard let previousReviewId = currentState.previousReviewId else {
                steps.accept(AppStep.back(animated: true))
                return .empty()
            }
            
            switch traverseMode {
            case .home:
                return provider.homeService.reviewDetail(reviewId: previousReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .insertFrontReviewData($0.result) }
            case .store:
                return provider.showRoomService.reviewDetail(reviewId: previousReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .insertFrontReviewData($0.result) }
                
            case .myReview:
                return provider.userService.myReviewDetail(reviewId: previousReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .insertFrontReviewData($0.result) }
                
            case .bookmarkedReview:
                return provider.userService.bookmarkReviewDetail(reviewId: previousReviewId)
                    .data().decode(type: ReviewDetailResponse.self, decoder: JSONDecoder())
                    .map { .insertFrontReviewData($0.result) }
            }
            
        case .bookmarkButtonDidTap(let reviewId):
            return provider.showRoomService.reviewBookmark(reviewId: reviewId)
                .data().decode(type: BaseResponse.self, decoder: JSONDecoder())
                .flatMap { _ in Observable.empty() }
            
        case .showRoomButtonDidTap(let storeId):
            steps.accept(AppStep.showRoomDetail(storeId))
            return .empty()
            
        case .removeButtonDidTap(let reviewId):
            provider.showRoomService.removeReview(reviewId: reviewId)
                .data().decode(type: BaseResponse.self, decoder: JSONDecoder())
                .subscribe(onNext: { [weak self] responseData in
                    if responseData.isSuccess {
                        self?.steps.accept(AppStep.back(animated: true))
                    }
                })
                .disposed(by: disposeBag)
            
            return .empty()
            
        case .reportButtonDidTap(let reviewId):
            steps.accept(AppStep.reportReview(reviewId))
            return .empty()
            
        case .exitButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case.setReviewData(let result):
            state.previousReviewId = result.reviewInquiry?.prevReviewID
            state.nextReviewId = result.reviewInquiry?.nextReviewID
            state.reviewData = [result]
            state.currentShowingReviewId = result.reviewID
            
        case .appendReviewData(let result):
            state.reviewData.append(result)
            state.currentShowingReviewId = result.reviewID
            state.nextReviewId = result.reviewInquiry?.nextReviewID
            
        case .insertFrontReviewData(let result):
            state.reviewData.insert(result, at: 0)
            state.currentShowingReviewId = result.reviewID
            state.previousReviewId = result.reviewInquiry?.prevReviewID
        }
        
        return state
    }
}
