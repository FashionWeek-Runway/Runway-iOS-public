//
//  RWAllStoreCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/08.
//

import UIKit

final class RWAllStoreCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark"), for: .normal)
        button.setBackgroundImage(UIImage(named: "icon_tab_bookmark_selected"), for: .selected)
        return button
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .body2B
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let locationLabel: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setImage(UIImage(named: "icon_location_small"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        return button
    }()
    
    let tagStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.alignment = .fill
        return view
    }()
    
    static let identifier = "RWAllStoreCollectionViewCell"
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([imageView, bookmarkButton, tagStackView, locationLabel, storeNameLabel])
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.top.equalToSuperview().offset(12)
        }
        
        tagStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-12)
            $0.centerX.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.bottom.equalTo(tagStackView.snp.top).offset(-6)
            $0.centerX.equalToSuperview()
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(locationLabel.snp.top).offset(-2)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tagStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
}
