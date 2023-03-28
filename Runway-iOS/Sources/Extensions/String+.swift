//
//  String+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/16.
//

import Foundation
import Alamofire

extension String {
    static func limitedLengthString(_ string: String, length: Int) -> String { // limit
        if string.count > length {
            let index = string.index(string.startIndex, offsetBy: length)
            return String(string[..<index])
        } else {
            return string
        }
    }
}
