//
//  PhoneLoginViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import ReactorKit

final class PhoneLoginViewController: BaseViewController {
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont.headline1
        return label
    }()
    
    private let phoneNumberField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "전화번호 입력"
        field.textField.keyboardType = .phonePad
        return field
    }()
    
    private let passwordField: RWTextField = {
        let field = RWTextField()
        field.secureToggleButton.isHidden = false
        field.secureToggleButton.isSelected = true
        field.textField.isSecureTextEntry = true
        field.placeholder = "비밀번호 입력"
        return field
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: "비밀번호 찾기", attributes: [.font: UIFont.body2M]), for: .normal)
        return button
    }()
    
    private let loginButton: RWButton = {
        let button = RWButton()
        button.title = "로그인"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    private let signUpButton: RWButton = {
        let button = RWButton()
        button.title = "회원가입"
        button.type = .secondary
        return button
    }()
    
    private var accountNotExistAlert: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 20
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(hex: "#EF5B52", alpha: 0.1)
        label.text = "존재하지 않는 계정입니다."
        label.font = UIFont.body2
        label.textColor = UIColor.error
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - intiailizer
    
    init(with reactor: PhoneLoginReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        
        self.view.addSubviews([loginLabel, phoneNumberField, passwordField, forgotPasswordButton, loginButton, signUpButton, accountNotExistAlert])
        accountNotExistAlert.isHidden = true
        
        loginLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(50)
        }
        
        phoneNumberField.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        passwordField.snp.makeConstraints {
            $0.top.equalTo(phoneNumberField.snp.bottom).offset(28)
            $0.leading.trailing.equalTo(phoneNumberField)
        }
        
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(21)
            $0.trailing.equalToSuperview().offset(-19)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-23)
        }
        
        loginButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-70)
            $0.leading.equalToSuperview().offset(17)
            $0.trailing.equalToSuperview().offset(-23)
        }
        
        accountNotExistAlert.snp.makeConstraints {
            $0.bottom.equalTo(loginButton.snp.top).offset(-47)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(188)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -70
                self.loginButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.loginButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                    if keyboardHeight > 0 {
                        $0.leading.trailing.equalToSuperview()
                    } else {
                        $0.leading.equalToSuperview().offset(17)
                        $0.trailing.equalToSuperview().offset(-23)
                    }
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
}

extension PhoneLoginViewController: View {
    func bind(reactor: PhoneLoginReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: PhoneLoginReactor) {
        backButton.rx.tap
            .debug()
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        phoneNumberField.textField.rx.text
            .orEmpty
            .map { Reactor.Action.enterPhoneNumber($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordField.textField.rx.text
            .orEmpty
            .map { Reactor.Action.enterPassword($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        forgotPasswordButton.rx.tap
            .map { Reactor.Action.forgotPasswordButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .map { Reactor.Action.signUpButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .map { Reactor.Action.loginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: PhoneLoginReactor) {
        
        reactor.state.map { $0.phoneNumber }
            .bind(to: phoneNumberField.textField.rx.text )
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.shouldAlertAccountNotExist }
            .subscribe(onNext: { [weak self] show in
                self?.accountNotExistAlert.text = self?.reactor?.currentState.loginErrorMessage
                self?.accountNotExistAlert.isHidden = !show
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoginEnable }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
