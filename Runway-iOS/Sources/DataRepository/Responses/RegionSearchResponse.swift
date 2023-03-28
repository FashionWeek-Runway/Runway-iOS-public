//
//  RegionSearchResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/28.
//

import Foundation

// MARK: - RegionSearchresponse
struct RegionSearchResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [MapMarker]
}

//// MARK: - Result
//struct MapMarker: Codable {
//    let storeID: Int
//    let storeName, address: String
//    let latitude, longitude: Double
//
//    enum CodingKeys: String, CodingKey {
//        case storeID = "storeId"
//        case storeName, address, latitude, longitude
//    }
//}
