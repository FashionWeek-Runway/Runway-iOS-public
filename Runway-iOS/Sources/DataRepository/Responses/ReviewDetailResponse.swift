//
//  ReviewDetailResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/05.
//

import Foundation

struct ReviewDetailResponse: Codable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: ReviewDetailResponseResult
}

// MARK: - Result
struct ReviewDetailResponseResult: Codable {
    let isBookmarked: Bool?
    let bookmarkCount: Int
    let imageURL: String
    let isMine: Bool
    let profileImageURL: String?
    let nickname, regionInfo: String
    let reviewID: Int
    let reviewInquiry: ReviewInquiry?
    let storeID: Int
    let storeName: String

    enum CodingKeys: String, CodingKey {
        case isBookmarked = "bookmark"
        case bookmarkCount = "bookmarkCnt"
        case imageURL = "imgUrl"
        case isMine = "my"
        case nickname
        case profileImageURL = "profileImgUrl"
        case regionInfo
        case reviewID = "reviewId"
        case reviewInquiry
        case storeID = "storeId"
        case storeName
    }
}

// MARK: - ReviewInquiry
struct ReviewInquiry: Codable {
    let nextReviewID, prevReviewID: Int?

    enum CodingKeys: String, CodingKey {
        case nextReviewID = "nextReviewId"
        case prevReviewID = "prevReviewId"
    }
}

