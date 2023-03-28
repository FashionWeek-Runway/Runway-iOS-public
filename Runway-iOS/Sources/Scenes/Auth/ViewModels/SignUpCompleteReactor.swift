//
//  SignUpCompleteReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class SignUpCompleteReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case homeButtonDidTap
    }
    
    enum Mutation {
    }
    
    struct State{
        let nickname: String
        let styles: [String]
        let imageURL: String?
    }
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    init(provider: ServiceProviderType, nickname: String, styles: [String], imageURL: String?) {
        self.provider = provider
//        let categories = ["미니멀", "캐주얼", "스트릿", "빈티지", "페미닌", "시티보이"]
//        let categoryForRequestId = [1: "미니멀", 2: "캐주얼", 3: "시티보이", 4: "스트릿", 5: "빈티지", 6: "페미닌"]
//        if let nickname = provider.signUpService.signUpAsKakaoData?.nickname { // kakao
//            self.initialState = State(nickname: nickname,
//                                      styles: provider.signUpService.signUpAsKakaoData?.categoryList?.compactMap { categoryForRequestId[$0] } ?? [],
//                                      imageData: provider.signUpService.signUpAsKakaoData?.profileImageData)
//        } else if let nickname = provider.signUpService.signUpAsPhoneData?.nickname { // phone
//            self.initialState = State(nickname: nickname,
//                                      styles: provider.signUpService.signUpAsPhoneData?.categoryList?.compactMap { categoryForRequestId[$0] } ?? [],
//                                      imageData: provider.signUpService.signUpAsPhoneData?.profileImageData)
//        } else if let nickname = provider.signUpService.signUpAsAppleData?.nickname { // apple
//            self.initialState = State(nickname: nickname,
//                                      styles: provider.signUpService.signUpAsAppleData?.categoryList?.compactMap { categoryForRequestId[$0] } ?? [],
//                                      imageData: provider.signUpService.signUpAsAppleData?.profileImageData)
//        } else { // 오류케이스
//            self.initialState = State(nickname: "", styles: [], imageData: nil)
//        }
        self.initialState = State(nickname: nickname, styles: styles, imageURL: imageURL)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .homeButtonDidTap:
            self.provider.signUpService.removeAllSignUpDatas()
            steps.accept(AppStep.userIsLoggedIn)
            return .empty()
        }
    }
    
}

