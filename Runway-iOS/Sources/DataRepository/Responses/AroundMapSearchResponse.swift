//
//  AroundMapSearchResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/24.
//

import Foundation
import Alamofire

// MARK: - Welcome
struct AroundMapSearchResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: AroundMapSearchResponseResult?
}

// MARK: - Result
struct AroundMapSearchResponseResult: Codable {
    let isLast: Bool
    let contents: [AroundMapSearchResponseResultContent]
}

// MARK: - Content
struct AroundMapSearchResponseResultContent: Codable {
    let storeID: Int
    let storeImageURL: String
    let category: [String]
    let storeName: String
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case storeImageURL = "storeImg"
        case category, storeName
    }
}


struct AroundMapSearchContent {
    let storeID: Int
    let category: [String]
    let storeName: String
    var imageData: Data?
}
