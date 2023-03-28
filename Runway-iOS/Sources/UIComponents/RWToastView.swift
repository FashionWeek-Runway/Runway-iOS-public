//
//  RWToastView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/13.
//

import UIKit

final class RWToastView: UIView {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = .body1
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init()
        textLabel.text = message
    }
    
    private func configureUI() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 21
        self.alpha = 0.8
        self.clipsToBounds = true
        
        self.addSubview(textLabel)
        
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
        }
    }
}
