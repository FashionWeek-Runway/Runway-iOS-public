//
//  MainFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxFlow

final class MainFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    var provider: ServiceProviderType
    
    private let rootViewController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .white
        return tabBarController
    }()
    
    // MARK: - intializer
    
    init(with provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .userIsLoggedIn:
            return coordinateToMainTabScreen()
        case .userIsLoggedOut:
            return coordinateToMainLoginScreen()
        default:
            return .none
        }
    }
    
    private func coordinateToMainTabScreen() -> FlowContributors {        
        let homeFlow = HomeFlow(with: provider)
        let mapFlow = MapFlow(with: provider)
        let myPageFlow = MyPageFlow(with: provider)
        
        Flows.use(homeFlow, mapFlow, myPageFlow, when: .ready) { flow1Root, flow2Root, flow3Root in
            
            let homeTabbarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_home_off"), selectedImage: UIImage(named: "icon_home_on"))
            homeTabbarItem.imageInsets = UIEdgeInsets(top: 12.0, left: 0, bottom: -12.0, right: 0)
            flow1Root.tabBarItem = homeTabbarItem
            
            let mapTabbarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_location_off"), selectedImage: UIImage(named: "icon_location_on"))
            mapTabbarItem.imageInsets = UIEdgeInsets(top: 12.0, left: 0, bottom: -12.0, right: 0)
            flow2Root.tabBarItem = mapTabbarItem
            
            let myPageTabbarItem = UITabBarItem(title: nil, image: UIImage(named: "icon_my_off"), selectedImage: UIImage(named: "icon_my_on"))
            myPageTabbarItem.imageInsets = UIEdgeInsets(top: 12.0, left: 0, bottom: -12.0, right: 0)
            flow3Root.tabBarItem = myPageTabbarItem
            
            self.rootViewController.setViewControllers([flow1Root, flow2Root, flow3Root], animated: false)
            self.rootViewController.selectedIndex = 0
        }
        return .multiple(flowContributors: [.contribute(withNextPresentable: homeFlow, withNextStepper: OneStepper(withSingleStep: AppStep.homeTab)),
                                            .contribute(withNextPresentable: mapFlow, withNextStepper: OneStepper(withSingleStep: AppStep.mapTab)),
                                            .contribute(withNextPresentable: myPageFlow, withNextStepper: OneStepper(withSingleStep: AppStep.myPageTab))])
    }
    
    private func coordinateToHomeTab() -> FlowContributors {
        self.rootViewController.selectedIndex = 0
        
        return .none
    }
    
    private func coordinateToMapTab() -> FlowContributors {
        self.rootViewController.selectedIndex = 1
        
        return .none
    }
    
    private func coordinateToMyPageTab() -> FlowContributors {
        self.rootViewController.selectedIndex = 2
        
        return .none
    }
    
    private func coordinateToMainLoginScreen() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: AppStep.loginRequired)
    }
}
