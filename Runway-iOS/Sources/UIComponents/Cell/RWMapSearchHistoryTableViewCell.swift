//
//  RWSearchHistoryTableViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import UIKit
import RxSwift
import RxCocoa

final class RWMapSearchHistoryTableViewCell: UITableViewCell {
    
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
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .caption
        return label
    }()
    
    let removeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "icon_close_small"), for: .normal)
        return button
    }()
    
    static let identifier = "RWSearchHistoryTableViewCell"
    
    var disposeBag = DisposeBag()
    
    // MARK: - initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([iconImageView, titleLabel, dateLabel])
        contentView.addSubview(removeButton)
        iconImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        removeButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView.snp.centerY)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(4)
            $0.width.equalTo(199)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(removeButton.snp.leading)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
