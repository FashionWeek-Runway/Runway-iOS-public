//
//  UserPrivacyResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//

import Foundation

// MARK: - Welcome
struct UserPrivacyResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: UserPrivacyResponseResult
}

// MARK: - Result
struct UserPrivacyResponseResult: Codable {
    let social: Bool
    let phone: String?
    let kakao, apple: Bool
}
