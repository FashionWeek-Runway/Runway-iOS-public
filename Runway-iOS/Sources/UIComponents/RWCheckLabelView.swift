//
//  RWCheckLabelView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/12.
//

import UIKit

import RxSwift
import RxCocoa

final class RWCheckLabelView: UIView {
    
    var isEnabled = BehaviorRelay(value: false)
    
    let disposeBag = DisposeBag()
    
    let checkImage = UIImageView(image: UIImage(named: "check_off"))
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.body2
        label.textColor = .gray500
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        self.addSubviews([checkImage, textLabel])
        
        checkImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(checkImage.snp.trailing).offset(8)
        }
    }
    
    private func setRx() {
        isEnabled.asDriver()
            .drive(onNext: { [weak self] value in
                self?.checkImage.image = value ? UIImage(named: "check_on") : UIImage(named: "check_off")
                self?.textLabel.textColor = value ? .primary : .gray500
            })
            .disposed(by: disposeBag)
    }
}
