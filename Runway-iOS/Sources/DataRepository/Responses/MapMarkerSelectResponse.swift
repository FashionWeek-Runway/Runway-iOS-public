//
//  MapMarkerSelectResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/27.
//

import Foundation

// MARK: - Welcome
struct MapMarkerSelectResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: StoreInfo
}

// MARK: - Result
//struct MapMarkerSelectResponseResult: Codable {
//    let storeID: Int
//    let storeImage: String
//    let category: [String]
//    let storeName: String
//    let distance: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case storeID = "storeId", storeImage = "storeImg"
//        case category, storeName, distance
//    }
//}
