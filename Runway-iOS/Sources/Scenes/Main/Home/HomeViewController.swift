//
//  HomeViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import Kingfisher

final class HomeViewController: BaseViewController {
    
    private let pagerCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWHomePagerCollectionViewCell.self, forCellWithReuseIdentifier: RWHomePagerCollectionViewCell.identifier)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.bounces = false
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.getDeviceWidth(), height: UIScreen.getDeviceWidth() * 1.48)
        view.collectionViewLayout = layout
        return view
    }()
    
    private lazy var pageProgressBar: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.trackTintColor = .gray100
        view.progressTintColor = .point
        return view
    }()
    
    private let gradientTopArea: UIView = {
        let view = UIView()
        view.backgroundColor = nil
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.4).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.getDeviceWidth(), height: 140)
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }()
    
    private let guideLabelText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .headline4
        label.numberOfLines = 2
        return label
    }()
    
    private let categorySelectButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_filter"), for: .normal)
        return button
    }()
    
    private let showAllContentButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "전체보기", attributes: [.font: UIFont.body2M, .foregroundColor: UIColor.white]), for: .normal)
        button.setImage(UIImage(named: "icon_go_small"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets.left = 4
        return button
    }()
    
    private let similiarUserReviewLabel: UILabel = {
        let label = UILabel()
        label.text = "비슷한 취향의 사용자 후기"
        label.textColor = .runwayBlack
        label.font = .headline4
        return label
    }()
    
    private let emptyReviewImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_empty_review"))
        view.isHidden = true
        return view
    }()
    private let emptyReviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 내 취향의 후기가 없어요."
        label.font = .body1
        label.isHidden = true
        return label
    }()
    private let emptyReviewDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "스타일 카테고리를 추가해서\n다양한 후기를 만나보세요."
        label.textAlignment = .center
        label.font = .body2
        label.textColor = .gray500
        label.isHidden = true
        return label
    }()
    
    private let userReviewCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.showsHorizontalScrollIndicator = false
        view.register(RWHomeUserReviewCollectionViewCell.self, forCellWithReuseIdentifier: RWHomeUserReviewCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 132, height: 200)
        view.collectionViewLayout = layout
        return view
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.text = "흥미로운 가게 소식을 알려드려요"
        label.textColor = .runwayBlack
        label.font = .headline4
        return label
    }()
    
    private let emptyNoticeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_empty_notice"))
//        view.isHidden = true
        return view
    }()
    private let emptyNoticeLabel: UILabel = {
        let label = UILabel()
        label.text = "소식 준비 중이에요"
        label.font = .body1
//        label.isHidden = true
        return label
    }()
    
//    private let noticeCollectionView: UICollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
//        view.showsVerticalScrollIndicator = false
//        view.register(RWHomeNoticeCollectionViewCell.self, forCellWithReuseIdentifier: RWHomeNoticeCollectionViewCell.identifier)
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 4
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//        view.collectionViewLayout = layout
//        return view
//    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - initializer
    
    init(with reactor: HomeReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRx()
    }

    override func configureUI() {
        super.configureUI()
        view.addSubviews([scrollView])
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.width.verticalEdges.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        containerView.addSubviews([pagerCollectionView, pageProgressBar, gradientTopArea,
                                  similiarUserReviewLabel, emptyReviewImageView, emptyReviewTitleLabel, emptyReviewDescriptionLabel, userReviewCollectionView,
                                   noticeLabel, emptyNoticeLabel, emptyNoticeImageView
//                                  noticeLabel, noticeCollectionView
                                  ])
        
        pagerCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.getDeviceWidth() * 1.48)
        }
        
        pageProgressBar.snp.makeConstraints {
            $0.bottom.equalTo(pagerCollectionView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(3)
        }
        
        gradientTopArea.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        similiarUserReviewLabel.snp.makeConstraints {
            $0.top.equalTo(pagerCollectionView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        
        emptyReviewImageView.snp.makeConstraints {
            $0.top.equalTo(similiarUserReviewLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        emptyReviewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyReviewImageView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
        }
        
        emptyReviewDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emptyReviewTitleLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        userReviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(similiarUserReviewLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(200)
//            $0.bottom.equalToSuperview().offset(-(self.tabBarController?.tabBar.frame.height ?? 0.0) - 10.0)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalTo(userReviewCollectionView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
        }
        // 임시
        emptyNoticeImageView.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        emptyNoticeLabel.snp.makeConstraints {
            $0.top.equalTo(emptyNoticeImageView.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(self.tabBarController?.tabBar.frame.height ?? 0.0) - 10.0)
        }
//
//        noticeCollectionView.snp.makeConstraints {
//            $0.top.equalTo(noticeLabel.snp.bottom).offset(16)
//            $0.leading.equalToSuperview().offset(20)
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.height.equalTo(266)
//            $0.bottom.equalToSuperview()
//        }
        
        gradientTopArea.addSubviews([guideLabelText, categorySelectButton, showAllContentButton])
        guideLabelText.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        categorySelectButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-64)
        }
        
        showAllContentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-22.5)
        }
        
    }
    
    private func setRx() {
        pagerCollectionView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] offset in
                guard let self else { return }
                let percentage = (offset.x + self.pagerCollectionView.bounds.width) / self.pagerCollectionView.contentSize.width
                self.pageProgressBar.setProgress(Float(percentage), animated: false)
            }).disposed(by: disposeBag)
    }
}

extension HomeViewController: View {
    func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeReactor) {
        rx.viewWillAppear.map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        categorySelectButton.rx.tap
            .map { Reactor.Action.categorySelectButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        showAllContentButton.rx.tap
            .map { Reactor.Action.showAllContentButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pagerCollectionView.rx.modelSelected(HomeStoreResponseResult.self)
            .map {
                if $0.cellType == .store {
                    return Reactor.Action.pagerCellDidTap($0.storeID)
                } else {
                    return Reactor.Action.showAllContentButtonDidTap
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        userReviewCollectionView.rx.didEndDecelerating
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                let width = self.userReviewCollectionView.frame.width
                let contentWidth = self.userReviewCollectionView.contentSize.width
                let reachesEnd = (self.userReviewCollectionView.contentOffset.x) >= contentWidth - width
                
                if reachesEnd {
                    self.reactor?.action.onNext(.userReviewCollectionViewReachesEnd)
                }
            }).disposed(by: disposeBag)
        
        userReviewCollectionView.rx.modelSelected(HomeReviewResponseResultContent.self)
            .map { Reactor.Action.userReviewCellDidTap($0.reviewID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: HomeReactor) {
        reactor.state.map { $0.pagerData }
            .do(onNext: { [weak self] data in
                guard let self, data.count > 0 else { return }
                let percentage = CGFloat(data.count) / 100
                DispatchQueue.main.async {
                    self.pageProgressBar.setProgress(Float(percentage), animated: false)
                }
            })
            .bind(to: pagerCollectionView.rx.items(cellIdentifier: RWHomePagerCollectionViewCell.identifier, cellType: RWHomePagerCollectionViewCell.self)) { indexPath, item, cell
                in
                
                switch item.cellType {
                case .store:
                    cell.cellMode = .store
                    guard let imageUrl = URL(string: item.imageURL) else { return }
                    cell.imageView.kf.setImage(with: ImageResource(downloadURL: imageUrl))
                    cell.storeNameLabel.attributedText = NSAttributedString(
                        string: item.storeName,
                        attributes: [
                            .strokeColor: UIColor.white,
                            .foregroundColor: UIColor.primary,
                            .strokeWidth: -4.0,
                            .font: UIFont.font(.blackHanSansRegular, ofSize: 26)
                        ]
                    )
                    
                    let categories = item.categoryList.compactMap { $0 }
                    
                    if categories.count > 3 {
                        for i in 0...2 {
                            let button = UIButton()
                            button.setAttributedTitle(NSAttributedString(string: "# \(categories[i])", attributes: [.font: UIFont.button2, .foregroundColor: UIColor.point]), for: .normal)
                            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
                            button.backgroundColor = .primary
                            cell.categoryTagStackView.addArrangedSubview(button)
                        }
                        let restNumber = categories.count - 3
                        let button = UIButton()
                        button.setAttributedTitle(NSAttributedString(string: "+\(restNumber)", attributes: [.font: UIFont.button2, .foregroundColor: UIColor.point]), for: .normal)
                        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
                        button.backgroundColor = .primary
                        cell.categoryTagStackView.addArrangedSubview(button)
                    } else {
                        categories.forEach {
                            let button = UIButton()
                            button.setAttributedTitle(NSAttributedString(string: "# \($0)", attributes: [.font: UIFont.button2, .foregroundColor: UIColor.point]), for: .normal)
                            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
                            button.backgroundColor = .primary
                            cell.categoryTagStackView.addArrangedSubview(button)
                        }
                    }
                    cell.bookmarkButton.isSelected = item.isBookmarked
                    cell.bookmarkButton.rx.tap
                        .asDriver()
                        .drive(onNext: { _ in
                            cell.bookmarkButton.isSelected.toggle()
                            let action = Reactor.Action.pagerBookmarkButtonDidTap(item.storeID)
                            reactor.action.onNext(action)
                        }).disposed(by: cell.disposeBag)
                    
                    cell.addressLabel.setAttributedTitle(NSAttributedString(string: item.regionInfo,
                                                                            attributes: [.font: UIFont.body2M, .foregroundColor: UIColor.white]), for: .normal)
                case .showMoreShop: // last cell
                    cell.cellMode = .showMoreShop
                }
                
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.userReview }
            .do(onNext: { [weak self] reviews in
                [self?.emptyReviewImageView,
                 self?.emptyReviewTitleLabel,
                 self?.emptyReviewDescriptionLabel].forEach {
                    $0?.isHidden = !reviews.isEmpty
                }
                self?.userReviewCollectionView.isHidden = reviews.isEmpty
            })
            .bind(to: userReviewCollectionView.rx.items(cellIdentifier: RWHomeUserReviewCollectionViewCell.identifier, cellType: RWHomeUserReviewCollectionViewCell.self)) { indexPath, item, cell in
                guard let imageUrl = URL(string: item.imageURL) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: imageUrl))
                cell.addressLabel.text = item.regionInfo
            }.disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.nickname }
            .bind(onNext: { [weak self] nickname in
                self?.guideLabelText.text = "\(nickname)님의\n취향을 가득 담은 매장"
            }).disposed(by: disposeBag)
    }
}
