//
//  HomeReviewResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/07.
//

import Foundation

// MARK: - Welcome
struct HomeReviewResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: HomeReviewResponseResult
}

// MARK: - Result
struct HomeReviewResponseResult: Codable {
    let isLast: Bool
    let contents: [HomeReviewResponseResultContent]
}

// MARK: - Content
struct HomeReviewResponseResultContent: Codable {
    let reviewID: Int
    let imageURL: String
    let regionInfo: String
    let isRead: Bool

    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case imageURL = "imgUrl"
        case regionInfo
        case isRead = "read"
    }
}
