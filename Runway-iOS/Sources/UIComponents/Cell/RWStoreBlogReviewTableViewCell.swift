//
//  RWStoreBlogReviewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/04.
//

import UIKit

final class RWStoreBlogReviewTableViewCell: UITableViewCell {
    
    let blogImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let imageCountLabel: UIButton = {
        let button = UIButton()
        button.setBackgroundColor(.runwayBlack.withAlphaComponent(0.5), for: .normal)
        button.setInsets(forContentPadding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4), imageTitlePadding: 0.0)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body1M
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .body2
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    static let identifier = "RWStoreBlogReviewTableViewCell"
    
    var webURL: String? = nil
    
    // MARK: - initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([titleLabel, descriptionLabel, blogImageView])
        blogImageView.addSubview(imageCountLabel)
        
        blogImageView.snp.makeConstraints {
            $0.width.height.equalTo(108)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        imageCountLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(blogImageView.snp.leading).offset(-21)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(blogImageView.snp.leading).offset(-21)
            $0.bottom.equalToSuperview().offset(-14)
        }
    }
}
