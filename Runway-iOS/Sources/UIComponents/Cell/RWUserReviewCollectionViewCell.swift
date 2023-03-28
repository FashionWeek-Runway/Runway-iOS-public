//
//  RWUserReviewCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/03.
//

import UIKit

final class RWUserReviewCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    static let identifier = "RWUserReviewCollectionViewCell"
    
    var reviewId: Int? = nil
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([imageView])
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
