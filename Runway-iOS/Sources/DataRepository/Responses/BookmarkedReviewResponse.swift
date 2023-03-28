//
//  BookmarkedReviewResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//

import Foundation

// MARK: - Welcome
struct BookmarkedReviewResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: BookmarkedReviewResponseResult
}

// MARK: - Result
struct BookmarkedReviewResponseResult: Codable {
    let isLast: Bool
    let contents: [BookmarkedReviewResponseResultContent]
}

// MARK: - Content
struct BookmarkedReviewResponseResultContent: Codable {
    let reviewID: Int
    let imageURL: String
    let regionInfo: String

    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case imageURL = "imgUrl"
        case regionInfo
    }
}
