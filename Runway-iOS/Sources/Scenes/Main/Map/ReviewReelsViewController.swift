//
//  ReviewReelsViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

import Kingfisher

final class ReviewReelsViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.isPagingEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.bounces = false
        view.register(RWReviewReelsCollectionViewCell.self, forCellWithReuseIdentifier: RWReviewReelsCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.getDeviceWidth(), height: UIScreen.getDeviceHeight() - view.getSafeArea().top - view.getSafeArea().bottom)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        view.collectionViewLayout = layout
        return view
    }()
    
    // MARK: - initializer
    
    init(with reactor: ReviewReelsReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .runwayBlack
        
        view.addSubviews([collectionView])
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(view.getSafeArea().top)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-view.getSafeArea().bottom)
        }
    }
    
    private func presentDeleteActionSheet(reviewId: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.reactor?.action.onNext(Reactor.Action.removeButtonDidTap(reviewId))
            self.showRemoveToast()
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func presentReportActionSheet(reviewId: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "신고", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.reactor?.action.onNext(Reactor.Action.reportButtonDidTap(reviewId))
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func showRemoveToast() {
        UIWindow.makeToastAnimation(message: "후기가 삭제되었습니다.", .bottom)
    }
    
}

extension ReviewReelsViewController: View {
    func bind(reactor: ReviewReelsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ReviewReelsReactor) {
        rx.viewDidLoad.map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        

        collectionView.rx.swipeGesture(.left)
            .when(.recognized)
            .filter { _ in
                let currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width
                return Int(currentIndex)+1 == self.collectionView.numberOfItems(inSection: 0)
            }
            .map { _ in Reactor.Action.swipeNextReview }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        collectionView.rx.swipeGesture(.right)
            .when(.recognized)
            .filter { _ in
                let currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width
                return Int(currentIndex) == 0
            }
            .map { _ in Reactor.Action.swipePreviousReview }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        collectionView.rx.tapGesture()
//            .asLocation(in: self.collectionView)
//            .subscribe(onNext: { [weak self] location in
//                guard let self else { return }
//
//                let currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width
//                let pageSize = self.collectionView.frame.size.width / CGFloat(self.collectionView.numberOfItems(inSection: 0))
//
//                let nextContentOffset = CGPoint(x: self.collectionView.contentOffset.x + pageSize, y: self.collectionView.bounds.origin.y)
//
//                let prevContentOffset = CGPoint(x: self.collectionView.contentOffset.x - pageSize, y: self.collectionView.bounds.origin.y)
//
//                if location.x > self.collectionView.bounds.midX {
//                    self.collectionView.setContentOffset(nextContentOffset, animated: false)
//                } else {
//                    self.collectionView.setContentOffset(prevContentOffset, animated: false)
//                }
//            }).disposed(by: disposeBag)
        
        }
        
    
    private func bindState(reactor: ReviewReelsReactor) {
        // 추후 boxcube레이아웃으로 개선해보기
        reactor.state.map { $0.reviewData }
            .bind(to: collectionView.rx.items(cellIdentifier: RWReviewReelsCollectionViewCell.identifier, cellType: RWReviewReelsCollectionViewCell.self)) { indexPath, item, cell in
//                guard let reactor = self.reactor else { return }
                if let profileImageURL = item.profileImageURL, let url = URL(string: profileImageURL) {
                    cell.profileImageView.kf.setImage(with: ImageResource(downloadURL: url))
                }
                
                guard let imageURL = URL(string: item.imageURL) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: imageURL))
                cell.storeNameLabel.text = item.storeName
                cell.addressLabel.text = item.regionInfo
                cell.usernameLabel.text = item.nickname
                
                cell.bookmarkButton.isSelected = item.isBookmarked ?? false
                if item.isMine {
                    cell.bookmarkButton.isHidden = true
                }
                
                cell.bookmarkButton.rx.tap
                    .do(onNext: { cell.bookmarkButton.isSelected.toggle() })
                    .map { Reactor.Action.bookmarkButtonDidTap(item.reviewID) }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
                
                cell.exitButton.rx.tap
                    .map { Reactor.Action.exitButtonDidTap }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
                
                cell.bottomStoreButton.rx.tap
                    .map { Reactor.Action.showRoomButtonDidTap(item.storeID) }
                    .bind(to: reactor.action)
                    .disposed(by: self.disposeBag)
                
                cell.etcButton.rx.tap
                    .asDriver()
                    .drive(onNext: { [weak self] in
                        if item.isMine {
                            self?.presentDeleteActionSheet(reviewId: item.reviewID)
                        } else {
                            self?.presentReportActionSheet(reviewId: item.reviewID)
                        }
                    }).disposed(by: self.disposeBag)
                
            }.disposed(by: disposeBag)
    }
}
