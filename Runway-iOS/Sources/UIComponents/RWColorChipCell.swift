//
//  RWColorChipCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/24.
//

import UIKit

final class RWColorChipCell: UICollectionViewCell {
    
    static let identifier = "RWColorChipCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
    
}
