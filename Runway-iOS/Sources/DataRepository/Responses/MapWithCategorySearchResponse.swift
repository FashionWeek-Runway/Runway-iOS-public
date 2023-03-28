//
//  MapWithCategorySearchResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/22.
//

import Foundation

// MARK: - Welcome
struct MapWithCategorySearchResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [MapWithCategorySearchResponseResult]
}

// MARK: - Result
struct MapWithCategorySearchResponseResult: Codable {
    let storeID: Int
    let storeName: String
    let bookmark: Bool
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case storeName, bookmark, latitude, longitude
    }
}
