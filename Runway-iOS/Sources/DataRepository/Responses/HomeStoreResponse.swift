//
//  HomePagerResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/07.
//

import Foundation

// MARK: - Welcome
struct HomeStoreResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [HomeStoreResponseResult]
}

// MARK: - Result
struct HomeStoreResponseResult: Codable {
    let isBookmarked: Bool
    let imageURL: String
    let storeID: Int
    let storeName, regionInfo: String
    let categoryList: [String?]
    let bookmarkCount: Int

    enum CodingKeys: String, CodingKey {
        case isBookmarked = "bookmark"
        case imageURL = "imgUrl"
        case storeID = "storeId"
        case storeName, regionInfo, categoryList
        case bookmarkCount = "bookmarkCnt"
    }
    
    // last show more shop cell
    enum CellType {
        case store
        case showMoreShop
    }
    var cellType: CellType = .store
}
