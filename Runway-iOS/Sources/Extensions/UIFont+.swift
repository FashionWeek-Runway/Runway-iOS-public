//
//  UIFont+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/06.
//

import UIKit

enum FontName: String {
    case blackHanSansRegular = "BlackHanSans-Regular"
    case spoqaHanSansNeoBold = "SpoqaHanSansNeo-Bold"
    case spoqaHanSansNeoLight = "SpoqaHanSansNeo-Light"
    case spoqaHanSansNeoMedium = "SpoqaHanSansNeo-Medium"
    case spoqaHanSansNeoRegular = "SpoqaHanSansNeo-Regular"
    case spoqaHanSansNeoThin = "SpoqaHanSansNeo-Thin"
    case helvetica93ExtendedBlack = "Helvetica93-ExtendedBlack"
}

extension UIFont {
    
    static let headline1 = UIFont.font(.spoqaHanSansNeoBold, ofSize: 28)
    
    static let headline2 = UIFont.font(.spoqaHanSansNeoBold, ofSize: 24)
    
    static let headline3 = UIFont.font(.spoqaHanSansNeoBold, ofSize: 20)
    
    static let headline4 = UIFont.font(.spoqaHanSansNeoBold, ofSize: 18)
    
    static let headline4M = UIFont.font(.spoqaHanSansNeoMedium, ofSize: 18)
    
    static let headline5 = UIFont.font(.spoqaHanSansNeoBold, ofSize: 16)
    
    static let subheadline1 = UIFont.font(.spoqaHanSansNeoRegular, ofSize: 20)
    
    static let subheadline1B = UIFont.font(.spoqaHanSansNeoBold, ofSize: 20)
    
    static let body1B = UIFont.font(.spoqaHanSansNeoBold, ofSize: 16)
    
    static let body1M = UIFont.font(.spoqaHanSansNeoMedium, ofSize: 16)
    
    static let body1 = UIFont.font(.spoqaHanSansNeoRegular, ofSize: 16)
    
    static let body2M = UIFont.font(.spoqaHanSansNeoMedium, ofSize: 14)

    static let body2 = UIFont.font(.spoqaHanSansNeoRegular, ofSize: 14)
    
    static let body2B = UIFont.font(.spoqaHanSansNeoBold, ofSize: 14)
    
    static let caption = UIFont.font(.spoqaHanSansNeoRegular, ofSize: 12)
    
    static let caption2 = UIFont.font(.spoqaHanSansNeoMedium, ofSize: 10)
    
    static let button1 = UIFont.font(.spoqaHanSansNeoMedium, ofSize: 16)
    
    static let button2 = UIFont.font(.spoqaHanSansNeoMedium, ofSize: 12)
    
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}
