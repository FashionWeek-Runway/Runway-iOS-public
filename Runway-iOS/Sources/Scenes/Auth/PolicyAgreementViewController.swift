//
//  PolicyAgreementViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import ReactorKit

import SafariServices

final class PolicyAgreementViewController: BaseViewController {
    
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "런웨이 사용을 위해\n약관 동의가 필요해요."
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.subheadline1])
        attributedString.addAttribute(.font, value: UIFont.headline3, range: (text as NSString).range(of: "약관 동의"))
        label.attributedText = attributedString
        label.numberOfLines = 2
        return label
    }()
    
    private let allAgreeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    
    private let allAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "약관 전체 동의"
        label.font = .body1M
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    private let usagePolicyAgreeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    
    private let usagePolicyAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "이용약관 동의 (필수)"
        label.font = .body2
        return label
    }()
    
    private let usagePolicyDetailButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_right_grey"), for: .normal)
        return button
    }()
    
    private let privacyPolicyAgreeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    
    private let privacyPolicyAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 처리 방침 동의 (필수)"
        label.font = .body2
        return label
    }()
    
    private let privacyPolicyDetailButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_right_grey"), for: .normal)
        return button
    }()
    
    private let locationPolicyAgreeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    
    private let locationPolicyAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "위치정보 이용 약관 동의 (필수)"
        label.font = .body2
        return label
    }()
    
    private let locationPolicyDetailButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_right_grey"), for: .normal)
        return button
    }()
    
    private let marketingAgreeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "checkbox_off"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkbox_on"), for: .selected)
        return button
    }()
    
    private let marketingAgreeLabel: UILabel = {
        let label = UILabel()
        label.text = "마케팅 정보 수신 동의 (선택)"
        label.font = .body2
        return label
    }()
    
    private let marketingDetailButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_right_grey"), for: .normal)
        return button
    }()
    
    private let nextButton: RWButton = {
        let button = RWButton()
        button.title = "다음"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    // MARK: - initializer
    
    init(with reactor: PolicyAgreementReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRx()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addProgressBar()
        self.progressBar.setProgress(0.66, animated: false)
        
        let bottomPolicyButtonStackView = UIStackView(arrangedSubviews: [usagePolicyAgreeButton,
                                                                        privacyPolicyAgreeButton,
                                                                        locationPolicyAgreeButton,
                                                                        marketingAgreeButton])
        bottomPolicyButtonStackView.axis = .vertical
        bottomPolicyButtonStackView.spacing = 16
        
        let policyLabelStackView = UIStackView(arrangedSubviews: [usagePolicyAgreeLabel,
                                                                 privacyPolicyAgreeLabel,
                                                                 locationPolicyAgreeLabel,
                                                                 marketingAgreeLabel])
        policyLabelStackView.axis = .vertical
        policyLabelStackView.alignment = .leading
        policyLabelStackView.distribution = .equalCentering
        
        let detailButtonStackView = UIStackView(arrangedSubviews: [usagePolicyDetailButton,
                                                                  privacyPolicyDetailButton,
                                                                  locationPolicyDetailButton,
                                                                  marketingDetailButton])
        detailButtonStackView.axis = .vertical
//        detailButtonStackView.spacing = 16
        detailButtonStackView.distribution = .equalCentering
        
        self.view.addSubviews([guideTextLabel, allAgreeButton, allAgreeLabel,
                               divider,
                               bottomPolicyButtonStackView, policyLabelStackView, detailButtonStackView,
                              nextButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        allAgreeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26)
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(218)
        }
        
        allAgreeLabel.snp.makeConstraints {
            $0.leading.equalTo(allAgreeButton.snp.trailing).offset(12)
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(219)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(allAgreeLabel.snp.bottom).offset(21)
        }
        
        bottomPolicyButtonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(26)
            $0.top.equalTo(divider.snp.bottom).offset(20)
        }
        
        policyLabelStackView.snp.makeConstraints {
            $0.leading.equalTo(bottomPolicyButtonStackView.snp.trailing).offset(12)
            $0.top.equalTo(divider.snp.bottom).offset(22)
            $0.bottom.equalTo(bottomPolicyButtonStackView.snp.bottom)
        }
        
        detailButtonStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-26)
            $0.top.equalTo(divider.snp.bottom).offset(17)
            $0.bottom.equalTo(bottomPolicyButtonStackView.snp.bottom)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func setRx() {
        usagePolicyDetailButton.rx.tap
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
        
        privacyPolicyDetailButton.rx.tap
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
        
        locationPolicyDetailButton.rx.tap
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
        
        marketingDetailButton.rx.tap
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
    }

}


extension PolicyAgreementViewController: View {
    func bind(reactor: PolicyAgreementReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: PolicyAgreementReactor) {
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        allAgreeButton.rx.tap
            .map { Reactor.Action.allAgreeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        usagePolicyAgreeButton.rx.tap
            .map { Reactor.Action.usagePolicyAgreeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        privacyPolicyAgreeButton.rx.tap
            .map { Reactor.Action.privacyPolicyAgreeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        locationPolicyAgreeButton.rx.tap
            .map { Reactor.Action.locationPolicyAgreeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        marketingAgreeButton.rx.tap
            .map { Reactor.Action.marketingPolicyAgreeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .map { Reactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: PolicyAgreementReactor) {
        reactor.state.map { $0.isAllAgreePolicy }
            .bind(to: allAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isAgreeUsagePolicy }
            .bind(to: usagePolicyAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isAgreePrivacyPolicy }
            .bind(to: privacyPolicyAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isAgreeLocationPolicy }
            .bind(to: locationPolicyAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isAgreeMarketingPolicy }
            .bind(to: marketingAgreeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNextEnable }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
