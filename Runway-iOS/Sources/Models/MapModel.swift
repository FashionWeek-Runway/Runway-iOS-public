//
//  MapModel.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import UIKit

struct MapPointDataModel {
    let latitude: Double
    let longtitude: Double
    let storeName: String?
    let type: PointerType
}

enum PointerType {
    case normalStore
    case bookmarkStore
}

struct Location {
    let latitude: Double
    let longitude: Double
}
