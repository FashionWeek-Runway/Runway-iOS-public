//
//  MapMarkerData.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/23.
//

import Foundation

final class MapMarkerData {
    let storeID: Int
    let storeName: String
    let bookmark: Bool
    let latitude, longitude: Double
    
    init(storeID: Int, storeName: String, bookmark: Bool, latitude: Double, longitude: Double) {
        self.storeID = storeID
        self.storeName = storeName
        self.bookmark = bookmark
        self.latitude = latitude
        self.longitude = longitude
    }
}
