//
//  SettingViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

import SafariServices

final class SettingViewController: BaseViewController {
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "계정"
        label.font = .body2B
        label.textColor = .gray600
        return label
    }()
    
    private let privacyManageButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "개인 정보 관리", attributes: [.font: UIFont.body1M]), for: .normal)
        return button
    }()
    
    private let divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let inquiryLabel: UILabel = {
        let label = UILabel()
        label.text = "문의"
        label.font = .body2B
        label.textColor = .gray600
        return label
    }()
    
    private let storeAddRequestButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "쇼룸 추가 요청", attributes: [.font: UIFont.body1M]), for: .normal)
        return button
    }()
    
    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let policyLabel: UILabel = {
        let label = UILabel()
        label.text = "약관 및 정책"
        label.font = .body2B
        label.textColor = .gray600
        return label
    }()
    
    private let usagePolicyButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "이용약관", attributes: [.font: UIFont.body1M]), for: .normal)
        return button
    }()
    
    private let privacyPolicyButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "개인정보 처리 방침", attributes: [.font: UIFont.body1M]), for: .normal)
        return button
    }()
    
    private let locationUsageButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "위치정보 이용 약관", attributes: [.font: UIFont.body1M]), for: .normal)
        return button
    }()
    
    private let marketingAgreeButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "마케팅 정보 수신 동의 약관", attributes: [.font: UIFont.body1M]), for: .normal)
        return button
    }()
    
    
    private let divider3: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let versionGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "버전 정보"
        label.font = .body1M
        label.textColor = .black
        return label
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "버전 정보"
        label.font = .body1M
        label.textColor = .black
        return label
    }()
    
    private let divider4: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "로그아웃", attributes: [.font: UIFont.body1]), for: .normal)
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
    
    private let logoutAlertViewController: RWAlertViewController = {
        let viewController = RWAlertViewController()
        viewController.alertView.alertMode = .twoAction
        viewController.alertView.leadingButton.title = "취소"
        viewController.alertView.trailingButton.title = "로그아웃"
        viewController.alertView.titleLabel.text = "로그아웃"
        viewController.alertView.captionLabel.text = "RUNWAY의 힙한 매장을 볼 수 없어요.\n정말 로그아웃 하시겠어요?"
        return viewController
    }()
    // MARK: - initializer
    
    init(with reactor: SettingReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRx()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addNavigationTitleLabel("설정")
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.centerX.verticalEdges.equalToSuperview()
        }
        
        containerView.addSubviews([accountLabel, privacyManageButton, divider1,
                                  inquiryLabel, storeAddRequestButton, divider2,
                                  policyLabel, usagePolicyButton, privacyPolicyButton, locationUsageButton, marketingAgreeButton, divider3,
                                  versionGuideLabel, versionLabel, divider4, logoutButton])
        
        accountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        privacyManageButton.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        divider1.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(privacyManageButton.snp.bottom).offset(24)
            $0.height.equalTo(8)
        }
        
        inquiryLabel.snp.makeConstraints {
            $0.top.equalTo(divider1.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }
        
        storeAddRequestButton.snp.makeConstraints {
            $0.top.equalTo(inquiryLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        divider2.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(storeAddRequestButton.snp.bottom).offset(22)
            $0.height.equalTo(8)
        }
        
        policyLabel.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        usagePolicyButton.snp.makeConstraints {
            $0.top.equalTo(policyLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        privacyPolicyButton.snp.makeConstraints {
            $0.top.equalTo(usagePolicyButton.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        locationUsageButton.snp.makeConstraints {
            $0.top.equalTo(privacyPolicyButton.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        marketingAgreeButton.snp.makeConstraints {
            $0.top.equalTo(locationUsageButton.snp.bottom).offset(25)
            $0.leading.equalToSuperview().offset(20)
        }
        
        divider3.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(marketingAgreeButton.snp.bottom).offset(22)
            $0.height.equalTo(8)
        }
        
        versionGuideLabel.snp.makeConstraints {
            $0.top.equalTo(divider3.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        versionLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalTo(versionGuideLabel.snp.centerY)
        }
        
        divider4.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(versionGuideLabel.snp.bottom).offset(24)
            $0.height.equalTo(8)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(divider4.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
    }
    
    private func setRx() {
        storeAddRequestButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let url = URL(string: PolicyURL.STORE_ADD_REQUEST) else { return }
                let webView = SFSafariViewController(url: url)
                webView.modalPresentationStyle = .pageSheet
                webView.dismissButtonStyle = .close
                DispatchQueue.main.async {
                    self?.present(webView, animated: true)
                }
            }).disposed(by: disposeBag)
        
        usagePolicyButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let url = URL(string: PolicyURL.USAGE_POLICY) else { return }
                let webView = SFSafariViewController(url: url)
                webView.modalPresentationStyle = .pageSheet
                webView.dismissButtonStyle = .close
                DispatchQueue.main.async {
                    self?.present(webView, animated: true)
                }
            }).disposed(by: disposeBag)
        
        privacyPolicyButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let url = URL(string: PolicyURL.PRIVACY_POLICY) else { return }
                let webView = SFSafariViewController(url: url)
                webView.modalPresentationStyle = .pageSheet
                webView.dismissButtonStyle = .close
                DispatchQueue.main.async {
                    self?.present(webView, animated: true)
                }
            }).disposed(by: disposeBag)
        
        locationUsageButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let url = URL(string: PolicyURL.LOCATION_USAGE_POLICY) else { return }
                let webView = SFSafariViewController(url: url)
                webView.modalPresentationStyle = .pageSheet
                webView.dismissButtonStyle = .close
                DispatchQueue.main.async {
                    self?.present(webView, animated: true)
                }
            }).disposed(by: disposeBag)
    
        marketingAgreeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let url = URL(string: PolicyURL.MARKETING_INFORMATION_USAGE_POLICY) else { return }
                let webView = SFSafariViewController(url: url)
                webView.modalPresentationStyle = .pageSheet
                webView.dismissButtonStyle = .close
                DispatchQueue.main.async {
                    self?.present(webView, animated: true)
                }
            }).disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.present(self.logoutAlertViewController, animated: false)
                }
            }).disposed(by: disposeBag)
        
        logoutAlertViewController.alertView.leadingButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: false)
            }).disposed(by: disposeBag)
    }
}

extension SettingViewController: View {
    func bind(reactor: SettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SettingReactor) {
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidtap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        privacyManageButton.rx.tap
            .map { Reactor.Action.privacyManageButtonDidTap}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        logoutAlertViewController.alertView.trailingButton.rx.tap
            .map { Reactor.Action.logoutButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: SettingReactor) {
        reactor.state.map { $0.appVersion }
            .bind(to: versionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
