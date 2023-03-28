//
//  RWAlertView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/12.
//

import UIKit


final class RWAlertView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .headline4
        label.text = "비밀번호 변경 완료!"
        label.textAlignment = .center
        label.textColor = .runwayBlack
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body1
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let confirmButton: RWButton = {
        let button = RWButton()
        button.type = .primary
        button.title = "확인"
        return button
    }()
    
    let leadingButton: RWButton = {
        let button = RWButton()
        button.type = .secondary
        button.title = "아니요"
        button.setBackgroundColor(UIColor.gray50, for: .normal)
        return button
    }()
    
    let trailingButton: RWButton = {
        let button = RWButton()
        button.type = .primary
        button.title = "삭제"
        return button
    }()
    
    enum AlertMode {
        case twoAction
        case confirm
    }
    
    var alertMode: AlertMode = .confirm {
        didSet {
            switch alertMode {
            case .confirm:
                confirmButton.isHidden = false
                leadingButton.isHidden = true
                trailingButton.isHidden = true
            case .twoAction:
                confirmButton.isHidden = true
                leadingButton.isHidden = false
                trailingButton.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.addSubviews([titleLabel, captionLabel, confirmButton, leadingButton, trailingButton])
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-14)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        leadingButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.equalToSuperview().multipliedBy(0.5).offset(-19)
        }
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-14)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.equalToSuperview().multipliedBy(0.5).offset(-19)
        }
    }
}
