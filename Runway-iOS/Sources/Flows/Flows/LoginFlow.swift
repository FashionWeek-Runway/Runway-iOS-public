//
//  LoginFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import RxFlow
import UIKit

final class LoginFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    var provider: ServiceProviderType
    
    private let rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }()
    
    // MARK: - initializer
    
    init(with provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .toast(let message):
            return makeToastMessage(message)
        case .back(let animated):
            return backScreen(animated: animated)
        case .dismiss:
            return dismissScreen()
            
        case .loginRequired:
            return coordinateToMainLoginScreen()
            
        case .phoneNumberLogin:
            return coordinateToPhoneLoginScreen()
            
        case .forgotPassword:
            return coordinateToForgotPasswordScreen()
            
        case .forgotPasswordCertificationIsRequired(let phoneNumber):
            return coordinateToForgotPasswordPhoneCertificationScreen(phoneNumber: phoneNumber)
            
        case .userChangedPassword:
            return backToPhoneLogin()
            
        case .identityVerificationIsRequired:
            return coordinateToIdentityVerificationScreen()
            
        case .newPasswordInputRequired(let phoneNumber):
            return coordinateToNewPasswordInputScreen(phoneNumber: phoneNumber)
            
        case .phoneCertificationNumberIsRequired:
            return coordinateToPhoneCertificationScreen()
            
        case .passwordInputRequired:
            return coordinateToPasswordInputScreen()
            
        case .policyAgreementIsRequired:
            return coordinateToPolicyAgreeScreen()
            
        case .userIsLoggedIn:
            // TODO: 로그인 완료 이후...
            return .end(forwardToParentFlowWithStep: AppStep.userIsLoggedIn)
        case .profileSettingIsRequired:
            return coordinateToProfileSettingScreen()
            
        case .categorySettingIsRequired:
            return coordinateToCategorySettingScreen()
        case .signUpIsCompleted(let nickname, let styles, let imageURL):
            return coordinateToSignUpCompleteScreen(nickname: nickname, styles: styles, imageURL: imageURL)
        default:
            return .none
        }
    }
    
    private func makeToastMessage(_ message: String) -> FlowContributors {
        UIWindow.makeToastAnimation(message: message)
        return .none
    }
    
    private func backScreen(animated: Bool) -> FlowContributors {
        self.rootViewController.popViewController(animated: animated)
        return .none
    }
    
    private func backToPhoneLogin() -> FlowContributors {
        self.rootViewController.popToViewController(rootViewController.viewControllers[1], animated: true)
        return .none
    }
    
    private func dismissScreen() -> FlowContributors {
        self.rootViewController.dismiss(animated: true)
        return .none
    }
    
    private func coordinateToMainLoginScreen() -> FlowContributors {
        let reactor = MainLoginReactor(provider: provider)
        let viewController = MainLoginViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPhoneLoginScreen() -> FlowContributors {
        let reactor = PhoneLoginReactor(provider: provider)
        let viewController = PhoneLoginViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToForgotPasswordScreen() -> FlowContributors {
        let reactor = ForgotPasswordReactor(provider: provider)
        let viewController = ForgotPasswordViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToForgotPasswordPhoneCertificationScreen(phoneNumber: String?) -> FlowContributors {
        guard let phoneNumber = phoneNumber else { return .none }
        let reactor = ForgotPasswordPhoneCertificationNumberInputReactor(provider: provider, phoneNumber: phoneNumber)
        let viewController = ForgotPasswordPhoneCertificationNumberInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToNewPasswordInputScreen(phoneNumber: String?) -> FlowContributors {
        guard let phoneNumber = phoneNumber else { return .none }
        let reactor = NewPasswordInputReactor(provider: provider, phoneNumber: phoneNumber)
        let viewController = NewPasswordInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToIdentityVerificationScreen() -> FlowContributors {
        let reactor = IdentityVerificationReactor(provider: provider)
        let viewController = IdentityVerificationViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPhoneCertificationScreen() -> FlowContributors {
        let reactor = PhoneCertificationReactor(provider: provider)
        let viewController = PhoneCertificationNumberInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPasswordInputScreen() -> FlowContributors {
        let reactor = PasswordInputReactor(provider: provider)
        let viewController = PasswordInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPolicyAgreeScreen() -> FlowContributors {
        let reactor = PolicyAgreementReactor(provider: provider)
        let viewController = PolicyAgreementViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToProfileSettingScreen() -> FlowContributors {
        let reactor = ProfileSettingReactor(provider: provider)
        let viewController = ProfileSettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToCategorySettingScreen() -> FlowContributors {
        let reactor = CategorySettingReactor(provider: provider)
        let viewController = CategorySettingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToSignUpCompleteScreen(nickname: String, styles: [String], imageURL: String?) -> FlowContributors {
        let reactor = SignUpCompleteReactor(provider: provider, nickname: nickname, styles: styles, imageURL: imageURL)
        let viewController = SignUpCompleteViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
