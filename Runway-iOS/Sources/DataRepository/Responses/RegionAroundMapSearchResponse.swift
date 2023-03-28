//
//  RegionAroundMapSearchResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/01.
//

import Foundation

// MARK: - RegionAroundMapSearchResponse
struct RegionAroundMapSearchResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: RegionAroundMapSearchResponseResult
}

// MARK: - Result
struct RegionAroundMapSearchResponseResult: Codable {
    let isLast: Bool
    let contents: [StoreInfo]
}

//// MARK: - Content
//struct RegionAroundMapSearchResponseResultContent: Codable {
//    let storeID: Int
//    let storeImage: String
//    let category: [String]
//    let storeName: String
//    let distance: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case storeID = "storeId"
//        case storeImage = "storeImg"
//        case category, storeName, distance
//    }
//}
