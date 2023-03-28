//
//  RWHomeNoticeCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/07.
//

import UIKit

final class RWHomeNoticeCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .body1B
        label.numberOfLines = 0
        return label
    }()
    
    static let identifier = "RWHomeNoticeCollectionViewCell"
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([imageView, titleLabel])
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIScreen.getDeviceWidth() - 40) * 0.71)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(14)
            $0.leading.bottom.equalToSuperview()
        }
    }
}
