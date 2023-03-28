//
//  LoginResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation

// MARK: - Welcome
struct LoginResponse: Decodable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: Result
}

// MARK: - Result
struct Result: Decodable {
    let accessToken, refreshToken: String
    let profileImageURL, kakaoID: String?
    let userID: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
        case profileImageURL = "profileImgUrl"
        case kakaoID = "kakaoId"
        case userID = "userId"
    }
}
