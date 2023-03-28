//
//  LaunchScreenViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/16.
//

import UIKit
import Lottie

import RxFlow

final class LaunchScreenViewController: UIViewController {
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "logo_moving")
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let streetImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image_street_short"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let window: UIWindow
    let coordinator: FlowCoordinator
    
    // MARK: - initializer
    
    init(with window: UIWindow, coordinator: FlowCoordinator) {
        self.window = window
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.onboardBlue
        configureUI()
        animationView.play { done in
            if done {
                self.coordinateToAppFlow()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.stop()
    }
    
    private func configureUI() {
        view.addSubviews([animationView, streetImage])
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(view.getSafeArea().top + 72)
        }
        
        streetImage.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.getDeviceWidth() * 0.772)
        }
    }
    
    private func coordinateToAppFlow() {
        
        let provider: ServiceProviderType = DataRepository.shared
        let appFlow = AppFlow(with: window, provider: provider)
        let appStepper = AppStepper(provider: provider)
        
        coordinator.coordinate(flow: appFlow, with: appStepper)
        
        if provider.appSettingService.isLoggedIn == true {
            appStepper.steps.accept(AppStep.userIsLoggedIn)
        } else {
            appStepper.steps.accept(AppStep.loginRequired)
        }
        
        window.makeKeyAndVisible()
    }
}
