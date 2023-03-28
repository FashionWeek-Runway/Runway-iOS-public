//
//  RWMapSearchBarCollectionViewBookmarkCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/21.
//

import UIKit

final class RWMapSearchBarCollectionViewBookmarkCell: UICollectionViewCell {
    
    static let identifier: String = "RWMapSearchBarCollectionViewBookmarkCell"
    
    let title: String = "bookmark"
    
    let bookmarkImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_bookmark_grey_selected"))
        return view
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
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.gray200.cgColor
        self.backgroundColor = .gray50
        
        addSubviews([bookmarkImageView])
        bookmarkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
    }
    
    func setSelectedLayout(_ isSelected: Bool) {
        if isSelected {
            bookmarkImageView.image = UIImage(named: "icon_bookmark_selected")
            backgroundColor = .primary
            layer.borderWidth = 1
        } else {
            bookmarkImageView.image = UIImage(named: "icon_bookmark_grey_selected")
            backgroundColor = .gray50
            layer.borderWidth = 0
        }
    }
}

