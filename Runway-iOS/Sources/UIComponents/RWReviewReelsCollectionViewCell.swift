//
//  RWReviewReelsCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import UIKit

// - 추후 boxcube layout으로 개선해보기
final class RWReviewReelsCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_profile"))
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .body2B
        return label
    }()
    
    let etcButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_etc_white"), for: .normal)
        return button
    }()
    
    let exitButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_tab_close"), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_bookmark_medium"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_bookmark_green_big"), for: .selected)
        return button
    }()
    
    let bottomStoreButton: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.gray900, for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.gray800.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let locationIconView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_review_location"))
        return view
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .body2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray300
        label.font = .caption
        label.textAlignment = .left
        return label
    }()
    
    private let goIcon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_go"))
        return view
    }()
    
    static let identifier = "RWReviewReelsView"
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .runwayBlack
        addSubviews([imageView, profileImageView, usernameLabel, etcButton, exitButton, bookmarkButton, bottomStoreButton])
        
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-70)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(21)
            $0.width.height.equalTo(30)
        }
        
        usernameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        exitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(24)
        }
        
        etcButton.snp.makeConstraints {
            $0.trailing.equalTo(exitButton.snp.leading).offset(-12)
            $0.centerY.equalTo(exitButton.snp.centerY)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(imageView.snp.bottom).offset(-37)
        }
        
        bottomStoreButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-13)
            $0.height.equalTo(45)
        }
        
        bottomStoreButton.addSubviews([locationIconView, storeNameLabel, addressLabel, goIcon])
        
        locationIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(15)
            $0.height.width.equalTo(16)
        }
        storeNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        storeNameLabel.snp.makeConstraints {
            $0.leading.equalTo(locationIconView.snp.trailing).offset(8)
            $0.top.equalToSuperview().offset(13)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(storeNameLabel.snp.trailing).offset(6)
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalTo(goIcon.snp.leading).offset(-4)
        }
        
        goIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-6)
            $0.top.equalToSuperview().offset(13)
        }
    }
    
}
