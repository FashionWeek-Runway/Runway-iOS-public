//
//  MyPageInformationResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import Foundation

// MARK: - Welcome
struct MyPageInformationResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: MyPageInformationResponseResult
}

// MARK: - Result
struct MyPageInformationResponseResult: Codable {
    let imageURL: String?
    let nickname: String
    let ownerCheck: Bool

    enum CodingKeys: String, CodingKey {
        case imageURL = "imgUrl"
        case nickname, ownerCheck
    }
}
