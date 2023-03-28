//
//  MyPageReactor.swift
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


final class MyPageReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case viewWillAppear
        case settingButtonDidTap
        case profileImageButtonDidTap
        case myReviewCollectionViewReachesBottom
        case bookmarkedStoreCollectionViewReachesBottom
        case bookmarkedReviewCollectionViewReachesBottom
        
        case myReviewCollectionViewCellSelected(Int)
        case bookmarkedStoreCollectionViewCellSelected(Int)
        case bookmarkedReviewCollectionViewCellSelected(Int)
    }
    
    enum Mutation {
        case setProfileData(MyPageInformationResponseResult)
        case setMyReviewData(MyReviewResponseResult)
        case appendMyReviewData(MyReviewResponseResult)
        case setBookmarkedStoreData(BookmarkedStoreResponseResult)
        case appendBookmarkedStoreData(BookmarkedStoreResponseResult)
        case setBookmarkedReviewData(BookmarkedReviewResponseResult)
        case appendBookmarkedReviewData(BookmarkedReviewResponseResult)
    }
    
    struct State {
        var nickname: String? = nil
        var profileImageURL: String? = nil
        var myReviewDatas: [MyReviewResponseResultContent] = []
        var bookmarkedStoreDatas: [BookmarkedStoreResponseResultContent] = []
        var bookmarkedReviewDatas: [BookmarkedReviewResponseResultContent] = []
        
        var myReviewPage: Int = 0
        var myReviewIsLast: Bool = false
        
        var bookmarkedStorePage: Int = 0
        var bookmarkedStoreIsLast: Bool = false
        
        var bookmarkedReviewPage: Int = 0
        var bookmarkedReviewIsLast: Bool = false
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
                provider.userService.mypageInformation().data().decode(type: MyPageInformationResponse.self, decoder: JSONDecoder())
                    .map({ responseData -> Mutation in
                        return .setProfileData(responseData.result)
                    }),
                
                provider.userService.myReview(page: 0, size: 30).data().decode(type: MyReviewResponse.self, decoder: JSONDecoder())
                    .map({ responseData -> Mutation in
                        return .setMyReviewData(responseData.result)
                    }),
                
                provider.userService.bookmarkShowRooms(page: 0, size: 30).data().decode(type: BookmarkedStoreResponse.self, decoder: JSONDecoder())
                    .map { .setBookmarkedStoreData($0.result) },
                
                provider.userService.bookmarkReviewList(page: 0, size: 30).data().decode(type: BookmarkedReviewResponse.self, decoder: JSONDecoder())
                    .map { return .setBookmarkedReviewData($0.result)}
            ])
            
        case .settingButtonDidTap:
            steps.accept(AppStep.setting)
            return .empty()
            
        case .profileImageButtonDidTap:
            steps.accept(AppStep.editProfile)
            return .empty()
            
        case .myReviewCollectionViewReachesBottom:
            return currentState.myReviewIsLast ? .empty() : provider.userService.myReview(page: currentState.myReviewPage, size: 10).data().decode(type: MyReviewResponse.self, decoder: JSONDecoder())
                .map({ responseData -> Mutation in
                    return .appendMyReviewData(responseData.result)
                })
            
        case .bookmarkedStoreCollectionViewReachesBottom:
            return currentState.bookmarkedStoreIsLast ? .empty() : provider.userService.bookmarkShowRooms(page: currentState.bookmarkedStorePage, size: 10).data().decode(type: BookmarkedStoreResponse.self, decoder: JSONDecoder())
                .map { .appendBookmarkedStoreData($0.result) }
            
        case .bookmarkedReviewCollectionViewReachesBottom:
            return currentState.bookmarkedReviewIsLast ? .empty() : provider.userService.bookmarkReviewList(page: currentState.bookmarkedReviewPage, size: 10).data().decode(type: BookmarkedReviewResponse.self, decoder: JSONDecoder())
                .map { .appendBookmarkedReviewData($0.result) }
            
        case .myReviewCollectionViewCellSelected(let reviewId):
            steps.accept(AppStep.userReviewReels(Id: reviewId, mode: .myReview))
            return .empty()
            
        case .bookmarkedStoreCollectionViewCellSelected(let storeId):
            steps.accept(AppStep.showRoomDetail(storeId))
            return .empty()
            
        case .bookmarkedReviewCollectionViewCellSelected(let reviewId):
            steps.accept(AppStep.userReviewReels(Id: reviewId, mode: .bookmarkedReview))
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setProfileData(let data):
            state.nickname = data.nickname
            state.profileImageURL = data.imageURL
            
        case.setMyReviewData(let data):
            state.myReviewDatas = data.contents
            state.myReviewIsLast = data.isLast
            state.myReviewPage = 0
            if !data.isLast {
                state.myReviewPage += 1
            }
            
        case .appendMyReviewData(let data):
            state.myReviewDatas.append(contentsOf: data.contents)
            state.myReviewIsLast = data.isLast
            if !data.isLast {
                state.myReviewPage += 1
            }
            
        case .setBookmarkedStoreData(let result):
            state.bookmarkedStoreDatas = result.contents
            state.bookmarkedStoreIsLast = result.isLast
            state.bookmarkedStorePage = 0
            if !result.isLast {
                state.bookmarkedStorePage += 1
            }
            
        case .appendBookmarkedStoreData(let data):
            state.bookmarkedStoreDatas.append(contentsOf: data.contents)
            state.bookmarkedStoreIsLast = data.isLast
            if !data.isLast {
                state.bookmarkedStorePage += 1
            }
            
        case .setBookmarkedReviewData(let data):
            state.bookmarkedReviewDatas = data.contents
            state.bookmarkedReviewIsLast = data.isLast
            state.bookmarkedReviewPage = 0
            if !data.isLast {
                state.bookmarkedReviewPage += 1
            }
            
        case .appendBookmarkedReviewData(let data):
            state.bookmarkedReviewDatas.append(contentsOf: data.contents)
            state.bookmarkedReviewIsLast = data.isLast
            if !data.isLast {
                state.bookmarkedReviewPage += 1
            }
        }
        
        return state
    }
}
