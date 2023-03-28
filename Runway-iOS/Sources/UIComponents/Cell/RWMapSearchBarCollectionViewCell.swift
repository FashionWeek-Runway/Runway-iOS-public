//
//  RWMapSearchBarCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/21.
//

import UIKit

final class RWMapSearchBarCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "RWMapSearchBarCollectionViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body2M
        label.textColor = UIColor.gray600
        label.textAlignment = .center
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
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray200.cgColor
        self.layer.masksToBounds = true
        self.backgroundColor = .gray50
        
        addSubviews([titleLabel])
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.bottom.equalToSuperview().offset(-6)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
        }
    }
    
    func setSelectedLayout(_ isSelected: Bool) {
        if isSelected {
            titleLabel.textColor = .point
            titleLabel.font = .body2B
            backgroundColor = .primary
            layer.borderWidth = 1
        } else {
            titleLabel.textColor = UIColor.gray600
            titleLabel.font = .body2M
            backgroundColor = .gray50
            layer.borderWidth = 0
        }
    }
}
