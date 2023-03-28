//
//  AppleLoginResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/19.
//

import Foundation

// MARK: - Welcome
struct AppleLoginResponse: Decodable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: AppleLoginResponseResult
}

// MARK: - Result
struct AppleLoginResponseResult: Decodable {
    let accessToken, refreshToken: String?
    let checkUser: Bool
    let appleID: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken
        case appleID = "appleId"
        case checkUser, refreshToken
        case userID = "userId"
    }
}
