//
//  RWAroundEmptyView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/24.
//

import UIKit

final class RWAroundEmptyView: UIView {
    
    private let iconImageView = UIImageView(image: UIImage(named: "icon_store_empty"))
    
    private let guideTextLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 등록된 매장이 없습니다"
        label.font = .body1
        label.textColor = .runwayBlack
        return label
    }()
    
    private let guideCaptionLabel: UILabel = {
        let label = UILabel()
        label.text = "위치를 이동하거나 필터링 변경해보세요."
        label.font = .body2
        label.textColor = .gray500
        return label
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
        addSubviews([iconImageView, guideTextLabel, guideCaptionLabel])
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(110)
        }
        
        guideTextLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(29)
            $0.centerX.equalToSuperview()
        }
        
        guideCaptionLabel.snp.makeConstraints {
            $0.top.equalTo(guideTextLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
    }
}
