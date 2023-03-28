//
//  CategoryFilterMapData.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation

struct CategoryMapFilterData: Encodable {
    let category: [String]
    let latitude: Double
    let longitude: Double
}
