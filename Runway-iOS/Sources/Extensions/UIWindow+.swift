//
//  UIWindow+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/13.
//

import UIKit


extension UIWindow {
    
    static let window = UIApplication.shared.windows.first
    
    enum ToastMessageLocation {
        case center
        case bottom
    }
    
    static func makeToastAnimation(message: String, _ location: ToastMessageLocation = .center, _ bottomInset: CGFloat = 0.0) {
        let toastMessage = RWToastView(message: message)
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.addSubview(toastMessage)
        toastMessage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            if location == .center {
                $0.centerY.equalToSuperview()
            } else {
                $0.bottom.equalToSuperview().offset(-20 - (window?.safeAreaInsets.bottom ?? 0.0) - bottomInset)
            }
        }
        UIView.animate(withDuration: 1.0, delay: 1, options: .curveLinear, animations: {
            toastMessage.alpha = 0
        }, completion: {_ in toastMessage.removeFromSuperview() })
    }
}
