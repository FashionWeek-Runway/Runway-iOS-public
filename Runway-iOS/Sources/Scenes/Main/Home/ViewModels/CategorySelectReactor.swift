//
//  CategorySelectReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/08.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit
import RxFlow

import Alamofire

final class CategorySelectReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case selectCategory(String)
        case backButtonDidTap
        case confirmButtonDidTap
    }
    
    enum Mutation {
        case setIntialCategory([String])
        case selectCategory(String)
    }
    
    struct State {
        let nickname: String
        var isNextButtonEnabled: Bool = false

        
        var isSelected: [String: Bool] = Dictionary(uniqueKeysWithValues: FashionCategory.List.map { ($0, false) })
        let categories = FashionCategory.List
    }

    
    // MARK: - Properties
    
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    private let disposeBag = DisposeBag()
    
    let initialState: State
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType, nickname: String) {
        self.provider = provider
        self.initialState = State(nickname: nickname)
    }
    
    // MARK: - Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return provider.homeService.categories().data().decode(type: ExistCategoryResponse.self, decoder: JSONDecoder())
                .map { Mutation.setIntialCategory($0.result) }
        case .selectCategory(let category):
            return .just(.selectCategory(category))
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .confirmButtonDidTap:
            let selectedCategoryIndex = currentState.categories.filter({ currentState.isSelected[$0] == true })
                .map { FashionCategory.RequestIdDictionary[$0] }.compactMap { $0 }
            
            provider.homeService.categorySelect(categories: selectedCategoryIndex)
                .subscribe(onNext: { [weak self] data in
                    self?.steps.accept(AppStep.back(animated: true))
                }).disposed(by: disposeBag)
            
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setIntialCategory(let selectedCategories):
            selectedCategories.forEach {
                state.isSelected[$0] = true
            }
        case .selectCategory(let category):
            state.isSelected[category]?.toggle()
            state.isNextButtonEnabled = state.isSelected.contains(where: { $0.value == true })
        }
        
        return state
    }
}
