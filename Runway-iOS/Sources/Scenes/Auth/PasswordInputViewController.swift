//
//  PasswordInputViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import ReactorKit

final class PasswordInputViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "비밀번호를 입력해주세요"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.headline3])
        attributedString.addAttribute(.font, value: UIFont.subheadline1, range: (text as NSString).range(of: "를 입력해주세요"))
        label.attributedText = attributedString
        return label
    }()
    
    private let passwordField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "비밀번호 입력"
        field.secureToggleButton.isHidden = false
        field.textField.isSecureTextEntry = true
        field.textField.keyboardType = .asciiCapable
        field.secureToggleButton.isSelected = true
        return field
    }()
    
    private let englishValidationLabel: RWCheckLabelView = {
        let view = RWCheckLabelView()
        view.textLabel.text = "영문"
        return view
    }()
    
    private let numberValidationLabel: RWCheckLabelView = {
        let view = RWCheckLabelView()
        view.textLabel.text = "숫자"
        return view
    }()
    
    private let lengthValidationLabel: RWCheckLabelView = {
        let view = RWCheckLabelView()
        view.textLabel.text = "8~16자"
        return view
    }()
    
    private let passwordConfirmField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "비밀번호 확인"
        field.secureToggleButton.isHidden = false
        field.textField.keyboardType = .asciiCapable
        field.textField.isSecureTextEntry = true
        field.secureToggleButton.isSelected = true
        return field
    }()
    
    private let passwordEqualValidationLabel: RWCheckLabelView = {
        let view = RWCheckLabelView()
        view.textLabel.text = "비밀번호 일치"
        return view
    }()
    
    private let confirmButton: RWButton = {
        let button = RWButton()
        button.title = "다음"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    // MARK: - intializer
    
    init(with reactor: PasswordInputReactor) {
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
        addProgressBar()
        self.progressBar.setProgress(0.5, animated: false)
        
        let firstStackView = UIStackView(arrangedSubviews: [englishValidationLabel, numberValidationLabel, lengthValidationLabel])
        firstStackView.axis = .horizontal
        firstStackView.distribution = .fillProportionally
        firstStackView.spacing = 14
        
        self.view.addSubviews([guideTextLabel, passwordField, firstStackView, passwordConfirmField, passwordEqualValidationLabel,confirmButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
        }
        
        passwordField.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        firstStackView.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(204)
        }
        
        passwordConfirmField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(passwordField.snp.bottom).offset(58)
        }
        
        passwordEqualValidationLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(passwordConfirmField.snp.bottom).offset(8)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                guard let self = self else { return }
                let height = keyboardHeight > 0 ? -keyboardHeight + self.view.safeAreaInsets.bottom : -10
                self.confirmButton.layer.cornerRadius = keyboardHeight > 0 ? 0 : 4.0
                self.confirmButton.snp.updateConstraints {
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(height)
                    if keyboardHeight > 0 {
                        $0.leading.trailing.equalToSuperview()
                    } else {
                        $0.leading.equalToSuperview().offset(20)
                        $0.trailing.equalToSuperview().offset(-20)
                    }
                }
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
}


extension PasswordInputViewController: View {
    
    func bind(reactor: PasswordInputReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindAction(reactor: PasswordInputReactor) {
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordField.textField.rx.value
            .orEmpty
            .map { Reactor.Action.passwordFieldInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordConfirmField.textField.rx.value
            .orEmpty
            .map { Reactor.Action.passwordValidationFieldInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: PasswordInputReactor) {
        reactor.state.map { $0.isPasswordContainEnglish }
            .bind(to: englishValidationLabel.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPasswordLengthIsSuit }
            .bind(to: lengthValidationLabel.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isPasswordContainNumber }
            .bind(to: numberValidationLabel.isEnabled)
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.IsPasswordEqual }
            .bind(to: passwordEqualValidationLabel.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isNextEnable }
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
