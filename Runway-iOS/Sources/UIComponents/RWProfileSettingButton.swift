//
//  RWProfileSettingButton.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/14.
//

import UIKit

final class RWProfileSettingButton: UIButton {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_my_large"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#0A0A0A").withAlphaComponent(0.6)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.text = "편집"
        label.textColor = .white
        label.isUserInteractionEnabled = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.snp.makeConstraints {
            $0.width.height.equalTo(230)
        }
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray300.cgColor
        self.backgroundColor = .gray100
        self.layer.cornerRadius = 115
        self.clipsToBounds = true
        
        self.addSubviews([profileImageView, bottomView])
        bottomView.addSubview(bottomLabel)
        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(52)
            $0.width.equalTo(205)
            $0.centerX.equalToSuperview()
        }
        bottomLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
        }
    }
    
    func toSmallScale() {
        self.snp.updateConstraints {
            $0.width.height.equalTo(136)
        }
        self.bottomView.snp.updateConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(121.22)
        }
        self.bottomLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(3.73)
        }
        self.profileImageView.contentScaleFactor = 136 / 230
        self.layer.cornerRadius = 68
    }
    
    func toLargeScale() {
        self.snp.updateConstraints {
            $0.width.height.equalTo(230)
        }
        self.bottomView.snp.updateConstraints {
            $0.height.equalTo(52)
            $0.width.equalTo(205)
        }
        self.bottomLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(8)
        }
        self.profileImageView.contentScaleFactor = 1
        self.layer.cornerRadius = 115
    }
}
