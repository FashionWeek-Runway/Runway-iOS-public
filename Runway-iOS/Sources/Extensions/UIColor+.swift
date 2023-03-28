//
//  UIColor+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/06.
//

import UIKit

extension UIColor {
    
    static let runwayBlack  = UIColor(hex: "#0A0A0A")
    
    static let primary: UIColor = UIColor(hex: "#0433FF")
    
    static let point = UIColor(hex: "#BDFF00")
    
    static let gray50 = UIColor(hex: "#F5F6F8")
    
    static let gray100 = UIColor(hex: "#EEF0F3")
    
    static let gray200 = UIColor(hex: "#D8DBE2")
    
    static let gray300 = UIColor(hex: "#C1C4CC")
    
    static let gray400 = UIColor(hex: "#AFB2BB")
    
    static let gray500 = UIColor(hex: "#8E9198")
    
    static let gray600 = UIColor(hex: "#66686D")
    
    static let gray700 = UIColor(hex: "#535659")
    
    static let gray800 = UIColor(hex: "#36383A")
    
    static let gray900 = UIColor(hex: "#242528")
    
    static let error = UIColor(hex: "#EF5B52")
    
    static let blue100 = UIColor(hex: "#E6EBFF")
    
    static let blue200 = UIColor(hex: "#CDD6FF")
    
    static let blue500 = UIColor(hex: "#8199FF")
    
    static let blue600 = UIColor(hex: "#6885FF")
                                 
    static let blue900 = UIColor(hex: "#1D47FF")
    
    static let onboardBlue = UIColor(hex: "#305EF4")
    
    static let onboardBlueDown = UIColor(hex: "#1645DD")
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
