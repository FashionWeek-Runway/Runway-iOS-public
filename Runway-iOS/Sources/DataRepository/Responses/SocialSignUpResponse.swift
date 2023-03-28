//
//  SocialSignUpResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

// MARK: - Welcome
struct SocialSignUpResponse: Decodable {
    let isSuccess: Bool
    let code, message: String
    let result: SocialSignUpResult
}

// MARK: - Result
struct SocialSignUpResult: Decodable {
    let userID: Int
    let accessToken, refreshToken: String
    let imageURL: String?
    let nickname: String?
    let categoryList: [String]?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case accessToken, refreshToken
        case imageURL = "imgUrl"
        case nickname, categoryList
    }
}
