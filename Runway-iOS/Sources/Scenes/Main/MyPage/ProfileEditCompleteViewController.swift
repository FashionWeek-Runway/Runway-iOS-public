//
//  ProfileEditCompleteViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//


import UIKit
import ReactorKit
import RxSwift
import RxCocoa

import Kingfisher
import Lottie

final class ProfileEditCompleteViewController: BaseViewController {
    
    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "confetti")
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 변경 완료!"
        label.textColor = .white
        label.font = .headline2
        return label
    }()
    
    private let profileCard = RWProfileTagCardView()
    
    private let confirmButton: RWButton = {
        let button = RWButton()
        button.title = "확인"
        button.type = .blackPoint
        return button
    }()
    
    // MARK: - initializer
    
    init(with reactor: ProfileEditCompleteReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .runwayBlack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileCardScaleAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        animationView.stop()
    }
    
    
    override func configureUI() {
        super.configureUI()
        
        self.view.addSubviews([animationView, guideTextLabel, profileCard, confirmButton])
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        profileCard.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(79)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func profileCardScaleAnimation() {
        
        self.profileCard.layer.anchorPoint = CGPoint(x: 0.5, y: 0.4)
        self.profileCard.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3) {
            self.profileCard.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func scaleTransform(for view: UIView, scaledBy scale: CGPoint, aroundAnchorPoint relativeAnchorPoint: CGPoint) -> CGAffineTransform {
        let bounds = view.bounds
        let anchorPoint = CGPoint(x: bounds.width * relativeAnchorPoint.x, y: bounds.height * relativeAnchorPoint.y)
        return CGAffineTransform.identity
            .translatedBy(x: anchorPoint.x, y: anchorPoint.y)
            .scaledBy(x: scale.x, y: scale.y)
            .translatedBy(x: -anchorPoint.x, y: -anchorPoint.y)
    }

}

extension ProfileEditCompleteViewController: View {
    func bind(reactor: ProfileEditCompleteReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ProfileEditCompleteReactor) {
        
        confirmButton.rx.tap
            .map { Reactor.Action.confirmButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ProfileEditCompleteReactor) {
        reactor.state.map { $0.nickname }
            .bind(to: profileCard.nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.imageURL }
            .bind(onNext: { [weak self] in
                self?.profileCard.defaultProfileImageView.isHidden = true
                guard let url = URL(string: $0) else { return }
                self?.profileCard.imageView.kf.setImage(with: ImageResource(downloadURL: url))
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.styles }
            .bind(onNext: { [weak self] in
                self?.profileCard.styles = $0
            }).disposed(by: disposeBag)
    }
}
