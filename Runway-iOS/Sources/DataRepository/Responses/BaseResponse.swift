//
//  BaseResponse.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

struct BaseResponse: Decodable {
    let code: String
    let isSuccess: Bool
    let message, result: String?
}
