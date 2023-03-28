//
//  RWMapSearchTableViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import UIKit

final class RWMapSearchTableViewCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .body2
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var regionId: Int? = nil
    
    var storeId: Int? = nil

    static let identifier = "RWMapSearchTableViewCell"
    
    // MARK: - initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([iconImageView, titleLabel, addressLabel])
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(4)
            $0.width.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.trailing.equalToSuperview()
        }
        
    }
}

