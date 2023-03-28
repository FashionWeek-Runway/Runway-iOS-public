//
//  RWSlider.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/24.
//

import UIKit

final class RWSlider: UIView {
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "polygon"))
        return imageView
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.transform = slider.transform.rotated(by: CGFloat(-0.5 * Float.pi))
        return slider
    }()
    
    // MARK: initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubviews([backgroundImageView, slider])
        backgroundImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }
        slider.snp.makeConstraints {
            $0.width.equalTo(snp.height)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}
