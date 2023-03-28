//
//  RWRadioSelector.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/13.
//

import UIKit

import RxSwift
import RxCocoa

final class RWRadioSelectorView: UIView {
    
    var selectedOption = PublishRelay<String?>()
    
    private let disposeBag = DisposeBag()
    
    lazy var leadingOptionButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray300.cgColor
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        button.layer.cornerRadius = 4
        button.setBackgroundColor(.blue100, for: .selected)
        button.setTitleColor(.gray600, for: .normal)
        button.setTitleColor(.runwayBlack, for: .selected)
        button.clipsToBounds = true
        return button
    }()
    
    lazy var trailingOptionButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray300.cgColor
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.layer.cornerRadius = 4
        button.setBackgroundColor(.blue100, for: .selected)
        button.setTitleColor(.gray600, for: .normal)
        button.setTitleColor(.runwayBlack, for: .selected)
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ leadingOption: String, _ trailingOption: String) {
        self.init()
        self.leadingOptionButton.setAttributedTitle(NSAttributedString(string: leadingOption, attributes: [.font: UIFont.body2]), for: .normal)
        self.leadingOptionButton.setAttributedTitle(NSAttributedString(string: leadingOption, attributes: [.font: UIFont.font(.spoqaHanSansNeoBold, ofSize: 14)]), for: .selected)
        self.trailingOptionButton.setAttributedTitle(NSAttributedString(string: trailingOption, attributes: [.font: UIFont.body2]), for: .normal)
        self.trailingOptionButton.setAttributedTitle(NSAttributedString(string: trailingOption, attributes: [.font: UIFont.font(.spoqaHanSansNeoBold, ofSize: 14)]), for: .selected)
    }
    
    private func configureUI() {
        addSubviews([leadingOptionButton, trailingOptionButton])
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        leadingOptionButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(self.snp.centerX)
        }
        
        trailingOptionButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(self.snp.centerX)
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
    
    private func setupEvent() {
        leadingOptionButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                if (self?.leadingOptionButton.isSelected == true) {
                    self?.selectedOption.accept(nil)
                    self?.leadingOptionButton.isSelected = false
                    self?.leadingOptionButton.layer.borderColor = UIColor.gray300.cgColor
                    self?.trailingOptionButton.layer.borderColor = UIColor.gray300.cgColor
                } else {
                    self?.leadingOptionButton.isSelected = true
                    self?.selectedOption.accept(self?.leadingOptionButton.attributedTitle(for: .normal)?.string ?? "")
                    self?.trailingOptionButton.isSelected = false
                    self?.leadingOptionButton.layer.borderColor = UIColor.primary.cgColor
                    self?.trailingOptionButton.layer.borderColor = UIColor.gray300.cgColor
                }
            }).disposed(by: disposeBag)
        
        trailingOptionButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                if (self?.trailingOptionButton.isSelected == true) {
                    self?.selectedOption.accept(nil)
                    self?.trailingOptionButton.isSelected = false
                    self?.leadingOptionButton.layer.borderColor = UIColor.gray300.cgColor
                    self?.trailingOptionButton.layer.borderColor = UIColor.gray300.cgColor
                } else {
                    self?.trailingOptionButton.isSelected = true
                    self?.selectedOption.accept(self?.trailingOptionButton.attributedTitle(for: .normal)?.string ?? "")
                    self?.leadingOptionButton.isSelected = false
                    self?.leadingOptionButton.layer.borderColor = UIColor.gray300.cgColor
                    self?.trailingOptionButton.layer.borderColor = UIColor.primary.cgColor
                }
            }).disposed(by: disposeBag)
    }
}
