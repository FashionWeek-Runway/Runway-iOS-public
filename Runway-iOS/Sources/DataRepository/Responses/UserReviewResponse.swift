//
//  UserReviewResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/04.
//

import Foundation

// MARK: - Welcome
struct UserReviewResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: UserReviewResponseResult
}

// MARK: - Result
struct UserReviewResponseResult: Codable {
    let isLast: Bool
    let contents: [UserReviewResponseResultContent]
}

// MARK: - Content
struct UserReviewResponseResultContent: Codable {
    let reviewID: Int
    let imgURL: String

    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case imgURL = "imgUrl"
    }
}
