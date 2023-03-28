//
//  ExistCategoryResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/08.
//

import Foundation

// MARK: - ExistCategoryResponse
struct ExistCategoryResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: [String]
}
