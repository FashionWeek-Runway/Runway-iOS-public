//
//  BookmarkedStoreResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/10.
//

import Foundation

// MARK: - Welcome
struct BookmarkedStoreResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: BookmarkedStoreResponseResult
}

// MARK: - Result
struct BookmarkedStoreResponseResult: Codable {
    let isLast: Bool
    let contents: [BookmarkedStoreResponseResultContent]
}

// MARK: - Content
struct BookmarkedStoreResponseResultContent: Codable {
    let storeID: Int
    let storeImg: String
    let category: [String]
    let storeName: String

    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case storeImg, category, storeName
    }
}

