//
//  NSCacheManager.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/23.
//

import Foundation

final class NSCacheManager<T> where T: AnyObject {
    let cache = NSCache<NSString, T>()
    
    func fetchObject(name: String) -> T? {
        return cache.object(forKey: name as NSString)
    }
    
    func saveObject(object: T, forKey key: String) {
        self.cache.setObject(object, forKey: NSString(string: key))
    }
}
