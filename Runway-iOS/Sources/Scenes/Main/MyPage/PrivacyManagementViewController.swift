//
//  PrivacyManagementViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//


import UIKit
import RxSwift
import RxCocoa
import ReactorKit

import SafariServices

final class PrivacyManagementViewController: BaseViewController {
    
    private let loginInformationLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인 정보"
        label.font = .body1B
        label.textColor = .runwayBlack
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "전화번호"
        label.font = .body1M
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        return label
    }()
    
    private let passwordChangeLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 변경"
        label.font = .body2
        return label
    }()
    
    private let passwordChangeButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "변경", attributes: [.font: UIFont.body2M, .foregroundColor: UIColor.primary]), for: .normal)
        button.setBackgroundColor(.blue100, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        return button
    }()
    
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let snsConnectLabel: UILabel = {
        let label = UILabel()
        label.text = "SNS 연결"
        label.font = .body2B
        return label
    }()
    
    private let snsConnectCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "연결된 SNS 계정으로 로그인할 수 있습니다."
        label.font = .body2
        label.textColor = .gray800
        return label
    }()
    
    private let alreadyConnectedLabel: UILabel = {
        let label = UILabel()
        label.text = "연결 완료"
        label.font = UIFont.body2M
        label.textColor = .gray600
        return label
    }()
    
    private let kakaoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_kakao"))
        return view
    }()
    
    private let kakaoConnectLabel: UILabel = {
        let label = UILabel()
        label.text = "카카오 로그인 연결"
        label.font = .body1
        return label
    }()
    
    private let kakaoConnectSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = .primary
        return view
    }()
    
    private let appleImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_apple"))
        return view
    }()
    
    private let appleConnectLabel: UILabel = {
        let label = UILabel()
        label.text = "애플 로그인 연결"
        label.font = .body1
        return label
    }()
    
    private let appleConnectSwitch: UISwitch = {
        let view = UISwitch()
        view.onTintColor = .primary
        return view
    }()
    
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "회원 탈퇴", attributes: [.foregroundColor: UIColor.gray800, .font: UIFont.body2]), for: .normal)
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let unlinkAlertViewController: RWAlertViewController = {
        let viewController = RWAlertViewController()
        viewController.alertView.alertMode = .twoAction
        viewController.alertView.leadingButton.title = "취소"
        viewController.alertView.trailingButton.title = "연결 해제"
        viewController.alertView.titleLabel.text = "계정 연결 해제"
        viewController.alertView.captionLabel.text = "[SNS] 계정 연결을 해제하시겠습니까?"
        return viewController
    }()
    
    // MARK: - Properties
    
    enum LoginMode {
        case kakao
        case apple
        case phone
    }
    
    let mode: LoginMode
    
    // MARK: - initializer
    
    init(with reactor: PrivacyManagementReactor, mode: LoginMode) {
        self.mode = mode
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
        addBackButton()
        addNavigationTitleLabel("개인 정보 관리")
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.centerX.verticalEdges.equalToSuperview()
        }
        
        switch mode {
        case .phone:
            containerView.addSubviews([loginInformationLabel,
                                       phoneLabel, phoneNumberLabel,
                                      passwordChangeLabel, passwordChangeButton, divider1,
                                       snsConnectLabel, snsConnectCaptionLabel,
                                       kakaoImageView, kakaoConnectLabel, kakaoConnectSwitch,
                                       appleImageView, appleConnectLabel, appleConnectSwitch,
                                       divider2, withdrawalButton
                                      ])
            loginInformationLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(24)
                $0.leading.equalToSuperview().offset(20)
            }
            
            phoneLabel.snp.makeConstraints {
                $0.top.equalTo(loginInformationLabel.snp.bottom).offset(34)
                $0.leading.equalToSuperview().offset(20)
            }
            
            phoneNumberLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalTo(phoneLabel.snp.centerY)
            }
            
            passwordChangeLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(55)
            }
            
            passwordChangeButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalTo(passwordChangeLabel.snp.centerY)
            }
            
            divider1.snp.makeConstraints {
                $0.top.equalTo(passwordChangeLabel.snp.bottom).offset(31)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(8)
            }
            
            snsConnectLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(divider1.snp.bottom).offset(24)
            }
            
            snsConnectCaptionLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(snsConnectLabel.snp.bottom).offset(12)
            }
            
            kakaoImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(snsConnectCaptionLabel.snp.bottom).offset(20)
            }
            
            kakaoConnectLabel.snp.makeConstraints {
                $0.leading.equalTo(kakaoImageView.snp.trailing).offset(12)
                $0.centerY.equalTo(kakaoImageView.snp.centerY)
            }
            
            kakaoConnectSwitch.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalTo(kakaoImageView.snp.centerY)
            }
            
            appleImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(kakaoImageView.snp.bottom).offset(18)
            }
            
            appleConnectLabel.snp.makeConstraints {
                $0.leading.equalTo(appleImageView.snp.trailing).offset(12)
                $0.centerY.equalTo(appleImageView.snp.centerY)
            }
            
            appleConnectSwitch.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalTo(appleImageView.snp.centerY)
            }
            
            divider2.snp.makeConstraints {
                $0.top.equalTo(appleImageView.snp.bottom).offset(24)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(8)
            }
            
            withdrawalButton.snp.makeConstraints {
                $0.top.equalTo(divider2.snp.bottom).offset(24)
                $0.leading.equalToSuperview().offset(20)
                $0.bottom.equalToSuperview().offset(-24)
            }
            
        case .kakao:
            containerView.addSubviews([snsConnectLabel, snsConnectCaptionLabel,
                                      kakaoImageView, kakaoConnectLabel,
                                      divider1, withdrawalButton, alreadyConnectedLabel])
            
            snsConnectLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(24)
                $0.leading.equalToSuperview().offset(20)
            }
            
            snsConnectCaptionLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(snsConnectLabel.snp.bottom).offset(12)
            }
            
            kakaoImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(snsConnectCaptionLabel.snp.bottom).offset(20)
            }
            
            kakaoConnectLabel.snp.makeConstraints {
                $0.leading.equalTo(kakaoImageView.snp.trailing).offset(12)
                $0.centerY.equalTo(kakaoImageView.snp.centerY)
            }
            
            alreadyConnectedLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalTo(kakaoConnectLabel.snp.centerY)
            }
            
            divider1.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.top.equalTo(kakaoImageView.snp.bottom).offset(24)
                $0.height.equalTo(8)
            }
            
            withdrawalButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(divider1.snp.bottom).offset(24)
                $0.bottom.equalToSuperview()
            }
            
        case .apple:
            containerView.addSubviews([snsConnectLabel, snsConnectCaptionLabel,
                                      appleImageView, appleConnectLabel,
                                      divider1, withdrawalButton, alreadyConnectedLabel])
            
            snsConnectLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(24)
                $0.leading.equalToSuperview().offset(20)
            }
            
            snsConnectCaptionLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(snsConnectLabel.snp.bottom).offset(12)
            }
            
            appleImageView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(snsConnectCaptionLabel.snp.bottom).offset(20)
            }
            
            appleConnectLabel.snp.makeConstraints {
                $0.leading.equalTo(appleImageView.snp.trailing).offset(12)
                $0.centerY.equalTo(appleImageView.snp.centerY)
            }
            
            alreadyConnectedLabel.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-20)
                $0.centerY.equalTo(appleConnectLabel.snp.centerY)
            }

            divider1.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.top.equalTo(appleImageView.snp.bottom).offset(24)
                $0.height.equalTo(8)
            }
            
            withdrawalButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(divider1.snp.bottom).offset(24)
                $0.bottom.equalToSuperview()
            }
        }
        
    }

}

extension PrivacyManagementViewController: View {
    func bind(reactor: PrivacyManagementReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: PrivacyManagementReactor) {
        rx.viewDidLoad.map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        kakaoConnectSwitch.rx.isOn
            .asDriver()
            .drive(onNext: {[weak self] isOn in
                guard let self else { return }
                if isOn {
                    let action = Reactor.Action.kakaoConnectSwitch(true)
                    self.reactor?.action.onNext(action)
                } else {
                    self.unlinkAlertViewController.alertView.tag = 1
                    self.present(self.unlinkAlertViewController, animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        appleConnectSwitch.rx.isOn
            .asDriver()
            .drive(onNext: {[weak self] isOn in
                guard let self else { return }
                if isOn {
                    let action = Reactor.Action.appleConnectSwitch(true)
                    self.reactor?.action.onNext(action)
                } else {
                    self.unlinkAlertViewController.alertView.tag = 2
                    self.present(self.unlinkAlertViewController, animated: false)
                }
            })
            .disposed(by: disposeBag)
        
        passwordChangeButton.rx.tap
            .map { Reactor.Action.passwordChangeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        unlinkAlertViewController.alertView.leadingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: false)
            }).disposed(by: disposeBag)
        
        unlinkAlertViewController.alertView.trailingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                if self?.unlinkAlertViewController.alertView.tag == 1 {
                    let action = Reactor.Action.kakaoConnectSwitch(false)
                    self?.reactor?.action.onNext(action)
                    UIWindow.makeToastAnimation(message: "카카오 계정 연결이 해제되었습니다.", .bottom, 20.0)
                } else {
                    let action = Reactor.Action.appleConnectSwitch(false)
                    self?.reactor?.action.onNext(action)
                }
                self?.dismiss(animated: false)
            }).disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidtap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        withdrawalButton.rx.tap
            .map { Reactor.Action.withdrawalButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: PrivacyManagementReactor) {
        reactor.state.compactMap { $0.phoneNumber }
            .bind(to: phoneNumberLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.iskakaoConnected }
            .bind(to: kakaoConnectSwitch.rx.isOn)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isAppleConnected }
            .bind(to: appleConnectSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
}
