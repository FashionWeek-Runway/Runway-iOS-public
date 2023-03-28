//
//  ExistingProfileResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//

import Foundation

// MARK: - Welcome
struct ExistingProfileResponse: Codable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: ExistingProfileResponseResult
}

// MARK: - Result
struct ExistingProfileResponseResult: Codable {
    let nickname: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case imageURL = "imgUrl"
        case nickname
    }
}
