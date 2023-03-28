//
//  MyReviewResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/08.
//

import Foundation

// MARK: - Welcome
struct MyReviewResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: MyReviewResponseResult
}

// MARK: - Result
struct MyReviewResponseResult: Codable {
    let isLast: Bool
    let contents: [MyReviewResponseResultContent]
}

// MARK: - Content
struct MyReviewResponseResultContent: Codable {
    let reviewID: Int
    let imageURL: String
    let regionInfo: String

    enum CodingKeys: String, CodingKey {
        case reviewID = "reviewId"
        case imageURL = "imgUrl"
        case regionInfo
    }
}
