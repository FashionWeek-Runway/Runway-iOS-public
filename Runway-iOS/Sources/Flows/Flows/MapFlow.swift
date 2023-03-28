//
//  MapFlow.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxFlow

final class MapFlow: Flow {
    
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
        // TODO: later
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .mapTab:
            return coordinateToMapTabScreen()
        case .mapSearch(let location):
            return coordinateToMapSearchScreen(mapLocation: location)
        case .showRoomDetail(let storeId):
            return coordinateToShowRoomDetailScreen(storeId: storeId)
        case .editReviewImage(let storeId, let data):
            return coordinateToEditReviewImageScreen(storeId: storeId, imageData: data)
        case .userReviewReels(let reviewId, let mode):
            return coordinateToReviewReelsScreen(reviewId: reviewId, mode: mode)
        case .reportReview(let reviewId):
            return coordinateToReviewReportingScreen(reviewId: reviewId)
        case .back(let animated):
            return back(animated: animated)
        default:
            return .none
        }
    }
    
    private func coordinateToMapTabScreen() -> FlowContributors {
        let reactor = MapReactor(provider: provider)
        let viewController = MapViewController(with: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func coordinateToMapSearchScreen(mapLocation: (Double, Double)) -> FlowContributors {
        let reactor = MapSearchReactor(provider: provider, mapLocation: mapLocation)
        let viewController = MapSearchViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: false)
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
    
    private func coordinateToReviewReportingScreen(reviewId: Int) -> FlowContributors {
        let reactor = ReviewReportingReactor(provider: provider)
        let viewController = ReviewReportingViewController(with: reactor)
        self.rootViewController.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    private func back(animated: Bool) -> FlowContributors {
        self.rootViewController.popViewController(animated: animated)
        return.none
    }
}
