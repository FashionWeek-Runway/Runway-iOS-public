//
//  RWColorInputAccessoryView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/24.
//

import UIKit

import RxSwift
import RxCocoa

final class RWColorInputAccessoryView: UIView {
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(RWColorChipCell.self, forCellWithReuseIdentifier: RWColorChipCell.identifier)
        collectionView.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 30, height: 30)
//        layout.minimumInteritemSpacing = (UIScreen.main.bounds.width - 250.0) / 6.0
        layout.minimumInteritemSpacing = 18.33
        collectionView.collectionViewLayout = layout
        return collectionView
    }()
    
    private let disposeBag = DisposeBag()
    
    var previousSelectedCellIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }
    }
    
    private func setRx() {
        Observable.of([UIColor.white, UIColor.runwayBlack, UIColor.primary, UIColor.point, UIColor(hex: "#FBFF28"), UIColor(hex: "#FC3A56"), UIColor(hex: "#D700E7")])
            .bind(to: collectionView.rx.items(cellIdentifier: RWColorChipCell.identifier, cellType: RWColorChipCell.self)) { indexPath, item, cell in
                cell.backgroundColor = item
            }.disposed(by: disposeBag)
    }
}
