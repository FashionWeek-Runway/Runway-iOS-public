//
//  SignUpAsPhoneResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/19.
//

import Foundation

// MARK: - Welcome
struct SignUpAsPhoneResponse: Codable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: SignUpAsPhoneResponseResult
}

// MARK: - Result
struct SignUpAsPhoneResponseResult: Codable {
    let accessToken, nickname: String
    let imageURL: String?
    let categoryList: [String]
    let refreshToken: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case accessToken, categoryList
        case imageURL = "imgUrl"
        case nickname, refreshToken
        case userID = "userId"
    }
}
