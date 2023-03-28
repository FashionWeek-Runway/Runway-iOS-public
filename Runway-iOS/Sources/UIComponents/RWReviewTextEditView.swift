//
//  RWReviewTextEditView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/24.
//

import UIKit

final class RWReviewTextEditView: UIView {

    let editCancelButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "취소", attributes: [.foregroundColor: UIColor.white, .font: UIFont.body1B]), for: .normal)
        return button
    }()
    
    let alignmentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_align_left"), for: .normal)
        button.tag = 1
        return button
    }()
    
    let colorPalleteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "color_pallete"), for: .normal)
        return button
    }()
    
    let editCompleteButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(string: "완료", attributes: [.foregroundColor: UIColor.white, .font: UIFont.body1B]), for: .normal)
        return button
    }()
    
    let slider: RWSlider = {
        let slider = RWSlider(frame: CGRect(x: 20, y: 65, width: 24, height: 240))
        slider.slider.maximumValue = 28.0
        slider.slider.minimumValue = 12.0
        slider.slider.value = 18.0
        return slider
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
        self.backgroundColor = .runwayBlack.withAlphaComponent(0.5)
        addSubviews([editCancelButton, alignmentButton, colorPalleteButton, editCompleteButton, slider])
        
        editCancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(13)
        }
        
        alignmentButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(12)
        }
        
        colorPalleteButton.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(12)
        }
        
        editCompleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(13)
        }
        
        slider.snp.makeConstraints {
            $0.top.equalTo(editCancelButton.snp.bottom).offset(42)
            $0.height.equalTo(240)
            $0.width.equalTo(24)
        }
    }
    
}
