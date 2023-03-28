//
//  MainLoginViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit
import ReactorKit
import RxFlow

final class MainLoginViewController: BaseViewController {
    
    private let logoTextImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "logo_text"))
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "내 손 안에 간편한\n패션 쇼핑 지도"
        label.textColor = .white
        label.font = .body1B
        return label
    }()
    
    private let streetImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "image_street_short"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let bottomArea: UIView = {
        let view = UIView()
        view.backgroundColor = .onboardBlueDown
        return view
    }()
    
    private let enterImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "enter_image"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let kakaoLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "kakao_button"), for: .normal)
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "apple_button"), for: .normal)
        return button
    }()
    
    private let phoneLoginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "phone_button"), for: .normal)
        return button
    }()
    
    
    // MARK: - initializer
    
    init(with reactor: MainLoginReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        self.view.backgroundColor = .onboardBlue
        self.view.addSubviews([logoTextImageView, titleLabel, streetImage, bottomArea, enterImage])
        
        logoTextImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.getSafeArea().top + 83)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoTextImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        streetImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.getDeviceWidth() * 0.772)
        }
        
        bottomArea.snp.makeConstraints {
            $0.top.equalTo(streetImage.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        enterImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-177)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [kakaoLoginButton, appleLoginButton, phoneLoginButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        self.view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(enterImage.snp.bottom).offset(20)
        }
    }
}

extension MainLoginViewController: View {
    func bind(reactor: MainLoginReactor) {
        
        kakaoLoginButton.rx.tap
            .map { Reactor.Action.kakaoLoginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .map { Reactor.Action.appleLoginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        phoneLoginButton.rx.tap
            .map { Reactor.Action.phoneLoginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
