//
//  MapService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

protocol MapSearchServiceProtocol {
    var event: PublishRelay<SearchEvent> { get }
}

enum SearchEvent {
    case store(StoreSearchDataType)
    case region(RegionSearchDataType)
}

enum StoreSearchDataType {
    case markerData(MapMarker)
    case sheetData(StoreInfo)
}

enum RegionSearchDataType {
    case markerDatas([MapMarker])
    case sheetDatas(RegionAroundMapSearchResponseResult, Int, String) // data, regionId, regionName
}

final class MapService: APIService, MapSearchServiceProtocol {
    
    var event = PublishRelay<SearchEvent>()
    
    func searchStore(storeId: Int) -> Observable<DataRequest> {
        return request(.get, "maps/\(storeId)")
    }
    
    func filterMap(data: CategoryMapFilterData) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(data.category, forKey: "category")
        params.updateValue(data.latitude, forKey: "latitude")
        params.updateValue(data.longitude, forKey: "longitude")
        
        return request(.post, "maps/filter", parameters: params)
    }
    
    func mapInfo(data: CategoryMapFilterData, page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(data.category, forKey: "category")
        params.updateValue(data.latitude, forKey: "latitude")
        params.updateValue(data.longitude, forKey: "longitude")
        
        return request(.post, "maps/info?page=\(page)&size=\(size)", parameters: params)
    }
    
    func mapInfoBottomSheet(storeId: Int) -> Observable<DataRequest> {
        return request(.get, "maps/info/\(storeId)")
    }
    
    func searchMapInfoRegion(regionId: Int, page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "maps/info/region/\(regionId)", parameters: params, encoding: URLEncoding.default)
    }
    
    func searchMapRegion(regionId: Int) -> Observable<DataRequest> {
        return request(.get, "maps/region/\(regionId)", encoding: URLEncoding.default)
    }
    
    func mapSearch(data: MapSearchData) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(data.content, forKey: "content")
        params.updateValue(data.latitude, forKey: "latitude")
        params.updateValue(data.longitude, forKey: "longitude")
        return request(.post, "maps/search", parameters: params)
    }
}
