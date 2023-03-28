//
//  RWReviewTextView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/24.
//

import UIKit

final class RWReviewTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.textAlignment = .left
        self.backgroundColor = .clear
        self.font = UIFont.headline1
        self.textColor = .white
    }
}
