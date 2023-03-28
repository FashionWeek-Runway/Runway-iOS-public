//
//  RWAroundView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/24.
//

import UIKit

final class RWAroundView: UIView {
    
    let regionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .runwayBlack
        label.font = .body1M
//        label.text = "[지역명] 둘러보기"
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        view.showsVerticalScrollIndicator = false
        view.collectionViewLayout = layout
        view.bounces = false
        view.register(RWAroundCollectionViewCell.self, forCellWithReuseIdentifier: RWAroundCollectionViewCell.identifier)
        return view
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubviews([regionLabel, collectionView])
        
        regionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-80)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(regionLabel.snp.bottom).offset(20)
        }
    }
}
