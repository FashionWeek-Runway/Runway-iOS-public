//
//  ShowRoomBlogsResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/04.
//

import Foundation


// MARK: - Welcome
struct ShowRoomBlogsResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [ShowRoomBlogsResponseResult]
}

// MARK: - Result
struct ShowRoomBlogsResponseResult: Codable {
    let webURL, imageURL: String
    let imageCount: Int
    let title, content: String

    enum CodingKeys: String, CodingKey {
        case webURL = "webUrl"
        case imageURL = "imgUrl"
        case title, content
        case imageCount = "imgCnt"
    }
}
