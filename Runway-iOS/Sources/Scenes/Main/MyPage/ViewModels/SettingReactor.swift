//
//  SettingReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import Alamofire


final class SettingReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case backButtonDidtap
        case privacyManageButtonDidTap
        case logoutButtonDidTap
    }
    
    enum Mutation {

    }
    
    struct State {
        let appVersion: String
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonDidtap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .privacyManageButtonDidTap:
            steps.accept(AppStep.privacyManagementNeeded)
            return .empty()
        case .logoutButtonDidTap:
            provider.appSettingService.logout()
            steps.accept(AppStep.userIsLoggedOut)
            return .empty()
        }
    }
}
