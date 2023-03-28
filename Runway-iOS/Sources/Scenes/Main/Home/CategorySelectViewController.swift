//
//  CategorySelectViewController.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/08.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit
import RxDataSources

final class CategorySelectViewController: BaseViewController {
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 스타일을 기반으로 매장을 추천해드려요."
        label.textColor = .gray700
        label.font = .body1
        return label
    }()
    
    private lazy var fashionStyleCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: .init())
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 14
        layout.estimatedItemSize = CGSize(width: 101, height: 42)
        view.collectionViewLayout = layout
        view.register(FashionStyleCollectionViewCell.self, forCellWithReuseIdentifier: FashionStyleCollectionViewCell.identifier)
        return view
    }()
    
    private let confirmButton: RWButton = {
        let button = RWButton()
        button.title = "적용"
        button.type = .primary
        button.isEnabled = false
        return button
    }()

    // MARK: - initializer
    
    init(with reactor: CategorySelectReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        addBackButton()
        addNavigationTitleLabel("카테고리 선택")
        
        self.view.addSubviews([guideTextLabel, captionLabel, fashionStyleCollectionView, confirmButton])
        
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(self.navigationBarArea.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(20)
        }
        
        fashionStyleCollectionView.snp.makeConstraints {
            $0.top.equalTo(captionLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(230)
            $0.height.equalTo(154)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
        }
    }

}

extension CategorySelectViewController: View {
    
    func bind(reactor: CategorySelectReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: CategorySelectReactor) {
        
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        fashionStyleCollectionView.rx.modelSelected(String.self)
            .map { Reactor.Action.selectCategory($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.backButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .do(onNext: { UIWindow.makeToastAnimation(message: "변경된 카테고리가 적용됐습니다.", .bottom)})
            .map { Reactor.Action.confirmButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: CategorySelectReactor) {
        
        reactor.state.map { $0.nickname }
            .bind(onNext: {[weak self] nickname in
                let text = "\(nickname)님의 옷 스타일을\n선택해주세요"
                let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.subheadline1])
                attributedString.addAttributes([.font: UIFont.headline3,
                                                .foregroundColor: UIColor.primary], range: (text as NSString).range(of: "\(nickname)"))
                self?.guideTextLabel.attributedText = attributedString
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.categories }
            .bind(to: fashionStyleCollectionView.rx.items(cellIdentifier: FashionStyleCollectionViewCell.identifier, cellType: FashionStyleCollectionViewCell.self)) { indexPath, item, cell in
                cell.titleLabel.text = reactor.currentState.categories[indexPath]
                cell.setSelectedLayout(reactor.currentState.isSelected[item] ?? false)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isNextButtonEnabled }
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}


