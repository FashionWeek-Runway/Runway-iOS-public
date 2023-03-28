//
//  FashionStyleCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/14.
//

import UIKit

final class FashionStyleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FashionStyleCollectionViewCell"
    
    let checkImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "check_off"))
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .gray600
        return label
    }()
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray300.cgColor
        
        self.addSubviews([checkImage, titleLabel])
        checkImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.width.height.equalTo(18)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkImage.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(42)
            $0.trailing.equalTo(titleLabel.snp.trailing).offset(14)
        }
    }
    
    func setSelectedLayout(_ isSelected: Bool) {
        if isSelected {
            checkImage.image = UIImage(named: "check_point")
            self.layer.borderWidth = 0
            self.backgroundColor = .primary
            self.titleLabel.font = .body1B
            self.titleLabel.textColor = .white
        } else {
            checkImage.image = UIImage(named: "check_off")
            self.layer.borderWidth = 1
            self.backgroundColor = .white
            self.titleLabel.font = .body1
            self.titleLabel.textColor = .gray600
        }
    }
}
