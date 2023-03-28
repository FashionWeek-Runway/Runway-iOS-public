//
//  MapSearchHistory.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/28.
//

import Foundation
import Realm
import RealmSwift

final class MapSearchHistory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var date: Date = Date()
    @Persisted var isStore: Bool
    @Persisted var storeId: Int? = nil
    @Persisted var regionId: Int? = nil
}
