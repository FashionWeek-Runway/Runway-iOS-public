//
//  RWButton.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import UIKit
import SnapKit

final class RWButton: UIButton {
    
    enum RWButtonType {
        case primary
        case secondary
        case point
        case blackPoint
    }
    
    var title: String? = nil {
        didSet {
            setAttributedTitle(NSAttributedString(string: title ?? "",
                                                  attributes: [.font: UIFont.button1]), for: .normal)
        }
    }
    
    var type: RWButtonType = .primary {
        didSet {
            switch type {
            case .primary:
                setTitleColor(.white, for: .normal)
                setTitleColor(.white, for: .disabled)
                self.layer.borderWidth = 0.0
                setBackgroundColor(.runwayBlack, for: .normal)
                setBackgroundColor(.gray300, for: .disabled)
            case .secondary:
                setTitleColor(.runwayBlack, for: .normal)
                setTitleColor(.gray300, for: .disabled)
                self.layer.borderWidth = 0.5
                self.layer.borderColor = currentTitleColor.cgColor
                setBackgroundColor(.white, for: .normal)
                setBackgroundColor(.white, for: .disabled)
            case .point:
                setTitleColor(.white, for: .normal)
                setTitleColor(.white, for: .disabled)
                self.layer.borderWidth = 0.0
                setBackgroundColor(.primary, for: .normal)
                setBackgroundColor(.primary, for: .disabled)
            case .blackPoint:
                setTitleColor(.primary, for: .normal)
                setTitleColor(.primary, for: .disabled)
                self.layer.borderWidth = 0.0
                setBackgroundColor(.point, for: .normal)
                setBackgroundColor(.point, for: .disabled)
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if type == .secondary {
                self.layer.borderColor = currentTitleColor.cgColor
            } else {
                self.layer.borderColor = nil
            }
        }
    }
    
    
    // MARK: - initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonType: RWButtonType) {
        self.init()
        self.type = buttonType
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
}
