//
//  ShowRoomDetailResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/03.
//

import Foundation

// MARK: - Welcome
struct ShowRoomDetailResponse: Codable {
    let code: String
    let isSuccess: Bool
    let message: String
    let result: ShowRoomDetailResponseResult
}

// MARK: - Result
struct ShowRoomDetailResponseResult: Codable {
    let storeID: Int
    let imageURLList: [String]
    let category: [String]
    let storeName, address, storeTime, storePhone: String
    let instagram, webSite: String
    let bookmark: Bool
    
    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case imageURLList = "imgUrlList"
        case category, storeName, address, storeTime, storePhone, instagram, webSite, bookmark
    }
}
