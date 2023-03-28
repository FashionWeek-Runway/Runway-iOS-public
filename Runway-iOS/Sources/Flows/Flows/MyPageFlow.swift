//
//  MyPageFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxFlow

final class MyPageFlow: Flow {
    
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
        case .myPageTab:
            return coordinateToMyPageScreen()
        case .showRoomDetail(let storeId):
            return coordinateToShowRoomDetailScreen(storeId: storeId)
        case .editReviewImage(let storeId, let imageData):
            return coordinateToEditReviewImageScreen(storeId: storeId, imageData: imageData)
        case .userReviewReels(let reviewId, let mode):
            return coordinateToReviewReelsScreen(reviewId: reviewId, mode: mode)
        case .reportReview(let reviewId):
            return coordinateToReviewReportingScreen(reviewId: reviewId)
        case .editProfile:
            return coordinateToProfileEditScreen()
        case .setting:
            return coordinateToSettingScreen()
        case .privacyManagementNeeded:
            return coordinateToPrivacyManagementScreen()
        case .passwordChange:
            return coordinateToPasswordChangeScreen()
        case .userPasswordChanged:
            return backToPrivacyManagementScreen()
        case .newPasswordInput:
            return coordinateToNewChangePasswordInputScreen()
        case .profileEditCompleted(let nickname, let styles, let imageURL):
            return coordinateToProfileEditCompletedScreen(nickname: nickname, styles: styles, imageURL: imageURL)
        case .confirmChangedProfile:
            return backToMyPageScreen()
        case .userIsLoggedOut:
            return coordinateToMainLoginScreen()
        case .withdrawalStep:
            return coordinateToWithdrawalScreen()
        case .back(let animated):
            return back(animated: animated)
        default:
            return .none
        }
    }
    
    private func coordinateToMyPageScreen() -> FlowContributors {
        let reactor = MyPageReactor(provider: provider)
        let viewController = MyPageViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToShowRoomDetailScreen(storeId: Int) -> FlowContributors {
        let reactor = ShowRoomDetailReactor(provider: provider, storeId: storeId)
        let viewController = ShowRoomDetailViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToEditReviewImageScreen(storeId: Int, imageData: Data) -> FlowContributors {
        let reactor = EditReviewReactor(provider: provider, storeId: storeId ,reviewImageData: imageData)
        let viewController = EditReviewViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToReviewReelsScreen(reviewId: Int, mode: AppStep.ReviewReelsMode) -> FlowContributors {
        var reactor: ReviewReelsReactor
        switch mode {
        case .home:
            reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .home)
        case .store:
            reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .store)
        case .myReview:
            reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .myReview)
        case .bookmarkedReview:
            reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .bookmarkedReview)
        }
        let viewController = ReviewReelsViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToUserReviewReelsScreen(reviewId: Int) -> FlowContributors {
        let reactor = ReviewReelsReactor(provider: provider, intialReviewId: reviewId, mode: .bookmarkedReview)
        let viewController = ReviewReelsViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToReviewReportingScreen(reviewId: Int) -> FlowContributors {
        let reactor = ReviewReportingReactor(provider: provider)
        let viewController = ReviewReportingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToSettingScreen() -> FlowContributors {
        let reactor = SettingReactor(provider: provider)
        let viewController = SettingViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToPrivacyManagementScreen() -> FlowContributors {
        let reactor = PrivacyManagementReactor(provider: provider)
        switch provider.appSettingService.lastLoginType {
        case .phone:
            let viewController = PrivacyManagementViewController(with: reactor, mode: .phone)
            self.rootViewController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
        case .kakao:
            let viewController = PrivacyManagementViewController(with: reactor, mode: .kakao)
            self.rootViewController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
        case .apple:
            let viewController = PrivacyManagementViewController(with: reactor, mode: .apple)
            self.rootViewController.pushViewController(viewController, animated: true)
            return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
        }
    }
    
    private func coordinateToPasswordChangeScreen() -> FlowContributors {
        let reactor = PasswordChangeReactor(provider: provider)
        let viewController = PasswordChangeViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToNewChangePasswordInputScreen() -> FlowContributors {
        let reactor = NewChangePasswordInputReactor(provider: provider)
        let viewController = NewChangePasswordInputViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func backToPrivacyManagementScreen() -> FlowContributors {
        self.rootViewController.popViewController(animated: false)
        self.rootViewController.popViewController(animated: false)
        return .none
    }
    
    private func coordinateToProfileEditScreen() -> FlowContributors {
        let reactor = ProfileEditReactor(provider: provider)
        let viewController = ProfileEditViewController(with: reactor)
        viewController.hidesBottomBarWhenPushed = true
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToProfileEditCompletedScreen(nickname: String, styles: [String], imageURL: String?) -> FlowContributors {
        let reactor = ProfileEditCompleteReactor(provider: provider,
                                                 nickname: nickname, styles: styles, imageURL: imageURL)
        let viewController = ProfileEditCompleteViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToWithdrawalScreen() -> FlowContributors {
        let reactor = WithdrawalReactor(provider: provider)
        let viewController = WithdrawalViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func backToMyPageScreen() -> FlowContributors {
        return .one(flowContributor: .forwardToCurrentFlow(withStep: AppStep.myPageTab))
    }
    
    private func coordinateToMainLoginScreen() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: AppStep.userIsLoggedOut)
    }
    
    private func back(animated: Bool) -> FlowContributors {
        self.rootViewController.popViewController(animated: animated)
        return .none
    }
}
