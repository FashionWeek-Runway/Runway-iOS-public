//
//  ProfileEditCompleteReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class ProfileEditCompleteReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case confirmButtonDidTap
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
    
    let categories = ["미니멀", "캐주얼", "스트릿", "빈티지", "페미닌", "시티보이"]
    let categoryForRequestId = [1: "미니멀", 2: "캐주얼", 3: "시티보이", 4: "스트릿", 5: "빈티지", 6: "페미닌"]
    
    init(provider: ServiceProviderType, nickname: String, styles: [String], imageURL: String?) {
        self.provider = provider
        self.initialState = State(nickname: nickname, styles: styles, imageURL: imageURL)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .confirmButtonDidTap:
            steps.accept(AppStep.confirmChangedProfile)
            return .empty()
        }
    }
    
}

