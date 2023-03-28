//
//  AppFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import RxFlow
import RxCocoa
import RxSwift

struct AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let provider: ServiceProviderType
    private let disposeBag: DisposeBag = .init()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
//    func readyToEmitSteps() {
//        provider.loginService.didLoginObservable
//            .map { $0 ? SampleStep.loginIsCompleted : SampleStep.loginIsRequired }
//            .bind(to: steps)
//            .disposed(by: disposeBag)
//    }
}

// Flow는 AnyObject를 준수하므로 class로 선언해주어야 한다.
final class AppFlow: Flow {
    var root: Presentable {
        return self.rootWindow
    }
    
    private let rootWindow: UIWindow
    private let provider: ServiceProviderType
    
    init(with window: UIWindow, provider: ServiceProviderType) {
        self.rootWindow = window
        self.provider = provider
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    /// 1. 바로 메인으로 이동
    /// 2. 로그인 필요
    /// 3. 로그인 완료
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep  else { return .none }
        
        switch step {
        /// 앱을 처음 시작해 로그인이 되어있지 않을 경우 로그인 화면으로 이동
        case .loginRequired:
            return coordinateToLoginViewController()
            
        case .userIsLoggedIn:
            return coordinateToMainVC()
            
        default:
            return .none
        }
    }
    
    private func coordinateToLoginViewController() -> FlowContributors {
        let loginFlow = LoginFlow(with: provider)
        
        Flows.use(loginFlow, when: .created) { [unowned self] root in
            self.rootWindow.rootViewController = root
        }
        
        let nextStep = OneStepper(withSingleStep: AppStep.loginRequired)
        
        return .one(flowContributor: .contribute(withNextPresentable: loginFlow,
                                                 withNextStepper: nextStep))
    }
    
    private func coordinateToMainVC() -> FlowContributors {
        let mainFlow = MainFlow(with: provider)
        
        Flows.use(mainFlow, when: .created) { [unowned self] root in
            self.rootWindow.rootViewController = root
        }
        
        let nextStep = OneStepper(withSingleStep: AppStep.userIsLoggedIn)
        
        return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: nextStep))
    }
}
