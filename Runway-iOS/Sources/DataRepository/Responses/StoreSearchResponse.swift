//
//  StoreSearchResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/28.
//

import Foundation

// MARK: - Welcome
struct StoreSearchResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: StoreSearchResponseResult
}

// MARK: - Result
struct StoreSearchResponseResult: Codable {
    let mapMarker: MapMarker
    let storeInfo: StoreInfo
}

// MARK: - MapMarker
struct MapMarker: Codable {
    let storeID: Int
    let storeName, address: String
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case storeName, address, latitude, longitude
    }
}

// MARK: - StoreInfo
struct StoreInfo: Codable {
    let storeID: Int
    let storeImage: String
    let category: [String]
    let storeName: String
    let distance: Double?

    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case storeImage = "storeImg"
        case category, storeName, distance
    }
}
