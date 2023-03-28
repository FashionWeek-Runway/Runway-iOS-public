//
//  AppSettingService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/07.
//

import Foundation

enum LoginType: String {
    case kakao
    case apple
    case phone
}

final class AppSettingService {
    
    static let shared = AppSettingService()
    
    private init() { }
    
    var authToken: String {
        get {
            return TokenUtils.shared.read(account: "authToken") ?? ""
        }
        set {
            return TokenUtils.shared.create(account: "authToken", value: newValue)
        }
    }
    
    var refreshToken: String {
        get {
            return TokenUtils.shared.read(account: "refreshToken") ?? ""
        }
        set {
            return TokenUtils.shared.create(account: "refreshToken", value: newValue)
        }
    }
    
    @UserDefault(key: "isLoggedIn", defaultValue: false)
    var isLoggedIn: Bool
    
    @UserDefault(key: "kakaoAccessToken", defaultValue: "")
    var kakaoAccessToken: String

    var lastLoginType: LoginType {
        get {
            return LoginType(rawValue: UserDefaults.standard.string(forKey: "lastLoginType") ?? "phone") ?? .phone
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "lastLoginType")
        }
    }
    
    var isFirstAppLaunch: Bool {
        get {
            let isFirstLaunch = UserDefaults.standard.bool(forKey: "hasBeenLaunchedAppBefore")
            if isFirstLaunch {
                UserDefaults.standard.set(true, forKey: "hasBeenLaunchedAppBefore")
            }
            return isFirstLaunch
        }
    }
    
    func removeSettings() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
    
    func logout() {
        isLoggedIn = false
        authToken = ""
        refreshToken = ""
        kakaoAccessToken = ""
    }
}
