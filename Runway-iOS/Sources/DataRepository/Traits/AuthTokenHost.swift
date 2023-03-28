//
//  AuthTokenHost.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/07.
//

import Foundation

protocol AuthTokenHost {
    var authToken: String { get set }
    var refreshToken: String { get set }
}

extension AuthTokenHost {
    var authToken: String {
        get {
            return AppSettingService.shared.authToken
        }
        
        set {
            AppSettingService.shared.authToken = newValue
        }
    }
    
    var refreshToken: String {
        get {
            return AppSettingService.shared.refreshToken
        }
        
        set {
            AppSettingService.shared.refreshToken = newValue
        }
    }
}
