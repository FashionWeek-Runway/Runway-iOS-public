//
//  PhoneCertificationNumberInputViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import UIKit

import RxSwift
import RxCocoa
import RxKeyboard
import ReactorKit

final class PhoneCertificationNumberInputViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        let text = "인증번호를 입력해주세요"
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.headline3])
        attributedString.addAttribute(.font, value: UIFont.subheadline1, range: (text as NSString).range(of: "를 입력해주세요"))
        label.attributedText = attributedString
        return label
    }()
    
    private let guideTextLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.body2
        label.text = "인증문자가"
        return label
    }()
    
    let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .body2M
        label.text = ""
        return label
    }()
    
    private let guideTextLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.body2
        label.text = "으로 발송되었습니다."
        return label
    }()
    
    private let verificationNumberInputField: RWTextField = {
        let field = RWTextField()
        field.placeholder = "숫자 6자리 입력"
        field.errorText = "인증번호가 일치하지 않습니다."
        field.textField.textContentType = .oneTimeCode
        field.textField.keyboardType = .phonePad
        return field
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .error
        label.font = .body2
        return label
    }()
    
    private let resendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.setBackgroundColor(.blue100, for: .normal)
        button.setBackgroundColor(.gray100, for: .disabled)
        button.setAttributedTitle(NSAttributedString(string: "재요청", attributes: [.font: UIFont.body2M, .foregroundColor: UIColor.primary]), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "재요청", attributes: [.font: UIFont.body2M, .foregroundColor: UIColor.gray500]), for: .disabled)
        return button
    }()
    
    private let confirmButton: RWButton = {
        let button = RWButton()
        button.title = "인증 확인"
        button.type = .primary
        button.isEnabled = false
        return button
    }()
    
    private let timerObservable: Observable<Int>? = Observable<Int>
        .interval(.seconds(1), scheduler: MainScheduler.instance)
    
    // MARK: - intializer
    
    init(with reactor: PhoneCertificationReactor) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addNavigationTitleLabel()
        addProgressBar()
        progressBar.setProgress(0.33, animated: false)
        phoneNumberLabel.text = reactor?.initialState.phoneNumber ?? ""
        
        self.view.addSubviews([guideTextLabel, guideTextLabel2, phoneNumberLabel, guideTextLabel3, verificationNumberInputField, confirmButton])
        
        verificationNumberInputField.addSubviews([timerLabel, resendButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
        }
        
        guideTextLabel2.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        guideTextLabel3.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel2.snp.top)
            $0.leading.equalToSuperview().offset(182)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(guideTextLabel2.snp.trailing).offset(4)
            $0.trailing.equalTo(guideTextLabel3.snp.leading).offset(-1)
            $0.top.equalTo(guideTextLabel2)
        }
        
        verificationNumberInputField.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel2.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        resendButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-6)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(67)
            $0.height.equalTo(36)
        }
        
        timerLabel.snp.makeConstraints {
            $0.trailing.equalTo(resendButton.snp.leading).offset(-14)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(29)
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

extension PhoneCertificationNumberInputViewController: View {
    func bind(reactor: PhoneCertificationReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: PhoneCertificationReactor) {
        
        timerObservable?.map { Reactor.Action.timer($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        verificationNumberInputField.textField.rx.value
            .orEmpty
            .map { Reactor.Action.verificationNumberInput($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        resendButton.rx.tap
            .map { Reactor.Action.resendButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.confirmButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: PhoneCertificationReactor) {
        reactor.state.map { $0.isRequestEnabled }
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.timerText }
            .bind(to: timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.timeSecond == 0 }
            .bind(to: resendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.invalidCertification }
            .bind(to: verificationNumberInputField.isError)
            .disposed(by: disposeBag)
    }
}
