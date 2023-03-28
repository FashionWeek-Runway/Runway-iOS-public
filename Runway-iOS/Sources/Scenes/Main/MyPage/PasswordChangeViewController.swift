//
//  PasswordChangeViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import ReactorKit

final class PasswordChangeViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "기존 비밀번호를 입력해주세요"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.headline3])
        attributedString.addAttribute(.font, value: UIFont.subheadline1, range: (text as NSString).range(of: "를 입력해주세요"))
        label.attributedText = attributedString
        return label
    }()
    
    private let passwordField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "기존 비밀번호 입력"
        field.errorText = "비밀번호가 일치하지 않습니다"
        field.secureToggleButton.isHidden = false
        field.textField.isSecureTextEntry = true
        field.textField.keyboardType = .asciiCapable
        field.secureToggleButton.isSelected = true
        return field
    }()
    
    private let confirmButton: RWButton = {
        let button = RWButton()
        button.title = "확인"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    // MARK: - intializer
    
    init(with reactor: PasswordChangeReactor) {
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
        addNavigationTitleLabel("비밀번호 변경")
        
        self.view.addSubviews([guideTextLabel, passwordField ,confirmButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
        }
        
        passwordField.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
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


extension PasswordChangeViewController: View {
    
    func bind(reactor: PasswordChangeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindAction(reactor: PasswordChangeReactor) {
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordField.textField.rx.value
            .orEmpty
            .map { Reactor.Action.passwordFieldInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: PasswordChangeReactor) {
        reactor.state.map { $0.isNotSamePassword }
            .skip(1)
            .bind(to: self.passwordField.isError)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.isNextEnable }
            .bind(to: self.confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
