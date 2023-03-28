//
//  MyPageViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

import Kingfisher

final class MyPageViewController: BaseViewController {
    
    private let myLabel: UILabel = {
        let label = UILabel()
        label.text = "MY"
        label.textColor = .runwayBlack
        label.font = .headline4
        return label
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_setting"), for: .normal)
        return button
    }()
    
//    private let scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.showsVerticalScrollIndicator = false
//        return view
//    }()
//
//    private let containerView = UIView()
    
    private let profileImageButton: UIButton = {
        let view = UIButton()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.setBackgroundImage(UIImage(named: "icon_profile_my"), for: .normal)
        return view
    }()
    private let penImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_pencil"))
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        label.font = .headline4M
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let myReviewTabButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_review"), for: .selected)
        button.setImage(UIImage(named: "icon_review_grey"), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "나의 후기", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.gray300]), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "나의 후기", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.black]), for: .selected)
        button.setBackgroundColor(.clear, for: .normal)
        button.isSelected = true
        button.alignVertical(spacing: 2.0)
        return button
    }()
    
    private let myReviewButtonBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .runwayBlack
        return view
    }()
    
    private let storedTabButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_bookmark_grey"), for: .normal)
        button.setImage(UIImage(named: "icon_bookmark_black"), for: .selected)
        button.setAttributedTitle(NSAttributedString(string: "저장", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.gray300]), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "저장", attributes: [.font: UIFont.body2, .foregroundColor: UIColor.black]), for: .selected)
        button.setBackgroundColor(.clear, for: .normal)
        button.alignVertical(spacing: 2.0)
        return button
    }()
    
    private let storedButtonBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .runwayBlack
        view.isHidden = true
        return view
    }()

    private let divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()

    private let myReviewEmptyImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_empty_review"))
        return view
    }()
    private let myReviewEmptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "내 스타일의 매장에 방문하고\n기록해보세요!"
        label.font = .body1
        label.textAlignment = .center
        return label
    }()
    
    private let myReviewCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWReviewCollectionViewCell.self, forCellWithReuseIdentifier: RWReviewCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.getDeviceWidth() - 6.0) / 3.0,
                                 height: ((UIScreen.getDeviceWidth() - 6.0) / 3.0) * 1.53)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        view.isScrollEnabled = false
        view.collectionViewLayout = layout
        view.bounces = false
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["매장", "사용자 후기"])
        view.setTitleTextAttributes([.font: UIFont.body2B], for: .selected)
        view.setTitleTextAttributes([.font: UIFont.body2], for: .normal)
        view.selectedSegmentIndex = 0
        view.isHidden = true
        return view
    }()
    
    private let storeEmptyImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_empty_bookmark"))
        view.isHidden = true
        return view
    }()
    private let storeEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "마음에 드는 매장을 저장해보세요"
        label.font = .body1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let storeCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        view.showsVerticalScrollIndicator = false
        view.collectionViewLayout = layout
        view.bounces = false
        view.register(RWAroundCollectionViewCell.self, forCellWithReuseIdentifier: RWAroundCollectionViewCell.identifier)
        view.isHidden = true
        return view
    }()
    
    private let userReviewCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        view.register(RWReviewCollectionViewCell.self, forCellWithReuseIdentifier: RWReviewCollectionViewCell.identifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (UIScreen.getDeviceWidth() - 6.0) / 3.0,
                                 height: ((UIScreen.getDeviceWidth() - 6.0) / 3.0) * 1.53)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        view.collectionViewLayout = layout
        view.isHidden = true
        return view
    }()
    
    private let userReviewEmptyImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon_empty_bookmark_mypage"))
        view.isHidden = true
        return view
    }()
    private let userReviewEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "마음에 드는 사용자 후기를 저장해보세요"
        label.font = .body1
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    
    // MARK: - initializer
    
    init(with reactor: MyPageReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRx()
        showMyReviewDatas()
    }
    
    override func configureUI() {
        super.configureUI()
        navigationBarArea.addSubviews([myLabel, settingButton])
        myLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-18)
        }
        
        view.addSubviews([myReviewEmptyImageView, myReviewEmptyLabel, storeEmptyImageView, storeEmptyLabel, userReviewEmptyImageView, userReviewEmptyLabel])
//        scrollView.snp.makeConstraints {
//            $0.horizontalEdges.equalToSuperview()
//            $0.top.equalTo(navigationBarArea.snp.bottom)
//            $0.bottom.equalToSuperview().offset(-(tabBarController?.tabBar.frame.height ?? 0.0))
//        }
        
//        scrollView.addSubview(containerView)
//        containerView.snp.makeConstraints {
//            $0.width.centerX.verticalEdges.equalToSuperview()
//        }
        
        view.addSubviews([profileImageButton, penImageView, helloLabel, nicknameLabel, divider,
                                   myReviewTabButton, myReviewButtonBottomLine,storedTabButton, storedButtonBottomLine, divider2,
                                   myReviewCollectionView,
                                  segmentedControl, storeCollectionView, userReviewCollectionView])

        
        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(2)
            $0.leading.equalToSuperview().offset(20)
        }
        
        penImageView.snp.makeConstraints {
            $0.bottom.equalTo(profileImageButton.snp.bottom)
            $0.trailing.equalTo(profileImageButton.snp.trailing).offset(6)
        }
        
        helloLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageButton.snp.trailing).offset(21)
            $0.top.equalTo(navigationBarArea.snp.bottom).offset(8)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(helloLabel.snp.bottom).offset(1)
            $0.leading.equalTo(profileImageButton.snp.trailing).offset(21)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(29)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        myReviewTabButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(divider.snp.bottom)
            $0.height.equalTo(65)
            $0.width.equalTo(CGFloat(UIScreen.getDeviceWidth()) / 2.0)
        }
        
        storedTabButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(divider.snp.bottom)
            $0.height.equalTo(65)
            $0.width.equalTo(CGFloat(UIScreen.getDeviceWidth()) / 2.0)
        }
        
        divider2.snp.makeConstraints {
            $0.top.equalTo(myReviewTabButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        myReviewButtonBottomLine.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(divider2.snp.top)
            $0.width.equalToSuperview().dividedBy(2.0)
            $0.height.equalTo(2.5)
        }
        
        storedButtonBottomLine.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(divider2.snp.top)
            $0.width.equalToSuperview().dividedBy(2.0)
            $0.height.equalTo(2.5)
        }
        
        myReviewEmptyImageView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(58)
            $0.centerX.equalToSuperview()
        }
        
        myReviewEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(myReviewEmptyImageView.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
        
        myReviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        storeEmptyImageView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(88)
            $0.centerX.equalToSuperview()
        }
        
        storeEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(storeEmptyImageView.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
        
        storeCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        userReviewEmptyImageView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(88)
            $0.centerX.equalToSuperview()
        }
        
        userReviewEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(userReviewEmptyImageView.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
        
        userReviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    
    }
    
    private func setRx() {
        myReviewTabButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.showMyReviewDatas()
            }).disposed(by: disposeBag)
        
        storedTabButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.myReviewTabButton.isSelected = false
                self?.myReviewButtonBottomLine.isHidden = true
                self?.storedTabButton.isSelected = true
                self?.storedButtonBottomLine.isHidden = false
                
                self?.segmentedControl.isHidden = false
                self?.myReviewEmptyImageView.isHidden = true
                self?.myReviewEmptyLabel.isHidden = true
                self?.myReviewCollectionView.isHidden = true
                
                if self?.segmentedControl.selectedSegmentIndex == 0 {
                    self?.showStoreDatas()
                } else {
                    self?.showUserReviewDatas()
                }
            }).disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .asDriver()
            .drive(onNext: { [weak self] in
                if self?.storedTabButton.isSelected == true {
                    if $0 == 0 {
                        self?.showStoreDatas()
                    } else {
                        self?.showUserReviewDatas()
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func showMyReviewDatas() {
        self.myReviewTabButton.isSelected = true
        self.myReviewButtonBottomLine.isHidden = false
        self.storedTabButton.isSelected = false
        self.storedButtonBottomLine.isHidden = true
        
        self.segmentedControl.isHidden = true
        self.storeEmptyImageView.isHidden = true
        self.storeEmptyLabel.isHidden = true
        self.storeCollectionView.isHidden = true
        self.userReviewEmptyImageView.isHidden = true
        self.userReviewEmptyLabel.isHidden = true
        self.userReviewCollectionView.isHidden = true
        
        if self.reactor?.currentState.myReviewDatas.isEmpty == true {
            self.myReviewEmptyImageView.isHidden = false
            self.myReviewEmptyLabel.isHidden = false
            self.myReviewCollectionView.isHidden = true
        } else {
            self.myReviewEmptyImageView.isHidden = true
            self.myReviewEmptyLabel.isHidden = true
            self.myReviewCollectionView.isHidden = false
        }
    }
    
    private func showStoreDatas() {
        self.userReviewEmptyImageView.isHidden = true
        self.userReviewEmptyLabel.isHidden = true
        self.userReviewCollectionView.isHidden = true
        
        if self.reactor?.currentState.bookmarkedStoreDatas.isEmpty == true {
            self.storeEmptyImageView.isHidden = false
            self.storeEmptyLabel.isHidden = false
            self.storeCollectionView.isHidden = true
        } else {
            self.storeCollectionView.isHidden = false
        }
    }
    
    private func showUserReviewDatas() {
        self.storeEmptyImageView.isHidden = true
        self.storeEmptyLabel.isHidden = true
        self.storeCollectionView.isHidden = true
        
        if self.reactor?.currentState.bookmarkedReviewDatas.isEmpty == true {
            self.userReviewEmptyImageView.isHidden = false
            self.userReviewEmptyLabel.isHidden = false
            self.userReviewCollectionView.isHidden = true
        } else {
            self.userReviewCollectionView.isHidden = false
        }
    }
}

extension MyPageViewController: View {
    func bind(reactor: MyPageReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: MyPageReactor) {
        rx.viewWillAppear.map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        profileImageButton.rx.tap
            .map { Reactor.Action.profileImageButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .map { Reactor.Action.settingButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        myReviewCollectionView.rx.modelSelected(MyReviewResponseResultContent.self)
            .map { Reactor.Action.myReviewCollectionViewCellSelected($0.reviewID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        storeCollectionView.rx.modelSelected(BookmarkedStoreResponseResultContent.self)
            .map { Reactor.Action.bookmarkedStoreCollectionViewCellSelected($0.storeID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        userReviewCollectionView.rx.modelSelected(BookmarkedReviewResponseResultContent.self)
            .map { Reactor.Action.bookmarkedReviewCollectionViewCellSelected($0.reviewID) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(reactor: MyPageReactor) {
        reactor.state.compactMap { $0.nickname }
            .bind(onNext: { [weak self] nickname in
                self?.nicknameLabel.text = nickname + "님"
            }).disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.profileImageURL }
            .bind(onNext: { [weak self] imageURL in
                guard let url = URL(string: imageURL) else { return }
                self?.profileImageButton.kf.setBackgroundImage(with: ImageResource(downloadURL: url), for: .normal,
                                                               options: [.processor(ResizingImageProcessor(referenceSize: CGSize(width: 60, height: 60)))])
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.myReviewDatas }
            .do(onNext: { [weak self] datas in
                if self?.myReviewTabButton.isSelected == true {
                    self?.showMyReviewDatas()
                }
            })
            .bind(to: myReviewCollectionView.rx.items(cellIdentifier: RWReviewCollectionViewCell.identifier, cellType: RWReviewCollectionViewCell.self)) { indexPath, item, cell in
                guard let url = URL(string: item.imageURL) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: url))
                cell.addressLabel.text = item.regionInfo
            }.disposed(by: disposeBag)
        
        let bookmarkedStoreObservable = reactor.state.map { $0.bookmarkedStoreDatas }
                
        bookmarkedStoreObservable
            .do(onNext: { [weak self] _ in
                if self?.storedTabButton.isSelected == true && self?.segmentedControl.selectedSegmentIndex == 0 {
                    self?.showStoreDatas()
                }
            })
            .bind(to: storeCollectionView.rx.items(cellIdentifier: RWAroundCollectionViewCell.identifier, cellType: RWAroundCollectionViewCell.self)) { indexPath, item, cell in
                guard let url = URL(string: item.storeImg) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: url))
                cell.storeNameLabel.text = item.storeName
                cell.tagRelay.accept(item.category)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.bookmarkedReviewDatas }
            .do(onNext: { [weak self] datas in
                if self?.storedTabButton.isSelected == true && self?.segmentedControl.selectedSegmentIndex == 1 {
                    self?.showUserReviewDatas()
                }
            })
            .bind(to: userReviewCollectionView.rx.items(cellIdentifier: RWReviewCollectionViewCell.identifier, cellType: RWReviewCollectionViewCell.self)) { indexPath, item, cell in
                guard let url = URL(string: item.imageURL) else { return }
                cell.imageView.kf.setImage(with: ImageResource(downloadURL: url))
                cell.addressLabel.text = item.regionInfo
            }.disposed(by: disposeBag)
        
    }
}
