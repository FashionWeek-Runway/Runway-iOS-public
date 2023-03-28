//
//  RWTagCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import UIKit

final class RWTagCollectionViewCell: UICollectionViewCell {
    
    let label: UILabel = {
        let view = UILabel()
        view.font = .font(.spoqaHanSansNeoMedium, ofSize: 12)
        view.textColor = .blue600
        return view
    }()
    
    static let identifier = "RWTagCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .blue200.withAlphaComponent(0.5)
        layer.borderColor = UIColor.blue200.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        clipsToBounds = true
        isUserInteractionEnabled = false
        
        addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }
    }
}
