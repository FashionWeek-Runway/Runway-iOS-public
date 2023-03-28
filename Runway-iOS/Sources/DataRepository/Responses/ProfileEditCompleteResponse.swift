//
//  ProfileEditCompleteResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//

import Foundation

// MARK: - Welcome
struct ProfileEditCompleteResponse: Codable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: ProfileEditCompleteResponseResult
}

// MARK: - Result
struct ProfileEditCompleteResponseResult: Codable {
    let categoryList: [String]
    let nickname: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case categoryList
        case imageURL = "imgUrl"
        case nickname
    }
}
