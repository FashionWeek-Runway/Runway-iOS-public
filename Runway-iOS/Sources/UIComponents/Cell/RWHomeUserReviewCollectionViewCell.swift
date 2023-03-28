//
//  RWHomeUserReviewCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/07.
//

import UIKit

final class RWHomeUserReviewCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let locationIcon = UIImageView(image: UIImage(named: "icon_location_small"))
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption
        label.textColor = .white
        return label
    }()
    
    static let identifier = "RWHomeUserReviewCollectionViewCell"
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([imageView, locationIcon, addressLabel])
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        locationIcon.snp.makeConstraints {
            $0.leading.equalTo(8)
            $0.bottom.equalTo(-9.5)
        }
        
        addressLabel.snp.makeConstraints {
            $0.bottom.equalTo(-8)
            $0.leading.equalTo(locationIcon.snp.trailing).offset(3)
        }
    }
}
