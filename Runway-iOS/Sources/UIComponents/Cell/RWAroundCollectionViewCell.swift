//
//  RWAroundCollectionViewCell.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/24.
//

import UIKit
import RxSwift
import RxCocoa

final class RWAroundCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let storeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline4
        label.textColor = .runwayBlack
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        return label
    }()
    
    let tagCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWTagCollectionViewCell.self, forCellWithReuseIdentifier: RWTagCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 59, height: 24)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        view.showsHorizontalScrollIndicator = false
        view.collectionViewLayout = layout
        return view
    }()
    
    static let identifier = "RWAroundCollectionViewCell"
    
    let tagRelay = PublishRelay<[String]>()
    
    private var disposeBag = DisposeBag()
    
    var storeId: Int? = nil
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        bindCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([imageView, storeNameLabel, tagCollectionView])
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.width.equalTo(UIScreen.getDeviceWidth() - 40)
            $0.height.equalTo((UIScreen.getDeviceWidth() - 40) * 0.75)
        }
        
        storeNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.top.equalTo(storeNameLabel.snp.bottom).offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24) // TODO: - 추후 2줄 변경 가능성
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindCollectionView() {
        tagRelay
            .bind(to: tagCollectionView.rx.items(cellIdentifier: RWTagCollectionViewCell.identifier, cellType: RWTagCollectionViewCell.self)) { indexPath, item, cell in
                cell.label.text = "# " + item
            }
            .disposed(by: disposeBag)
    }
}
