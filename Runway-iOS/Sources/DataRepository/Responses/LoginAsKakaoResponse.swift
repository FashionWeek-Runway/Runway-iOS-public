//
//  LoginAsKakaoResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/16.
//

import Foundation

// MARK: - Welcome
struct LoginAsKakaoResponse: Decodable {
    let code, message: String
    let result: LoginKakaoResult
    let isSuccess: Bool
}

// MARK: - Result
struct LoginKakaoResult: Decodable {
    let profileImageURL: String
    let kakaoID: String

    enum CodingKeys: String, CodingKey {
        case profileImageURL = "profileImgUrl"
        case kakaoID = "kakaoId"
    }
}
