//
//  RWTextField.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import UIKit

import RxSwift
import RxCocoa

final class RWTextField: UIView {
    
    var isError = BehaviorRelay(value: false)
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    let textField = UITextField()
    
    var bottomLine = UIView()

    var focusColor: UIColor = .black
    
    var unfocusColor: UIColor = .gray300 {
        didSet {
            bottomLine.backgroundColor = unfocusColor
        }
    }
    
    let secureToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "icon_pw"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_pw_off"), for: .selected)
        button.isHidden = true
        return button
    }()
    
    var placeholder: String? {
        didSet {
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.font: UIFont.font(.spoqaHanSansNeoRegular, ofSize: 16.0)])
        }
    }
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .body2
        label.textColor = .error
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    var errorText: String? = nil {
        didSet {
            errorLabel.text = errorText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.delegate = self
        configureUI()
        setupError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        self.textField.font = UIFont.font(.spoqaHanSansNeoRegular, ofSize: 16.0)
        self.layer.cornerRadius = 0.0
        self.layer.borderWidth = 0.0

        bottomLine.backgroundColor = unfocusColor
        self.textField.borderStyle = UITextField.BorderStyle.none
        
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        self.addSubview(secureToggleButton)
        secureToggleButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(24)
        }
        
        self.addSubview(textField)
        textField.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(secureToggleButton.snp.leading)
        }
        
        self.addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(self.snp.bottom).offset(8)
        }
        
        setupSecureButtonEvent()
    }
    
    private func setupSecureButtonEvent() {
        secureToggleButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.textField.isSecureTextEntry.toggle()
                self?.secureToggleButton.isSelected.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupError() {
        isError.asDriver()
            .drive(onNext: { [weak self] error in
                if error {
                    self?.bottomLine.backgroundColor = .error
                    self?.errorLabel.isHidden = false
                } else {
                    self?.bottomLine.backgroundColor = .gray300
                    self?.errorLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
}

extension RWTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.bottomLine.backgroundColor = focusColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.bottomLine.backgroundColor = unfocusColor
    }
}
