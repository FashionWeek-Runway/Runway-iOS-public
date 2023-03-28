//
//  MapReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation


import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import RealmSwift
import Alamofire


final class MapReactor: Reactor, Stepper {
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case exitButtonDidTap
        case selectFilter(String)
        case searchButtonDidTap
        case searchFieldDidTap
        
        case mapViewCameraPositionDidChanged((Double, Double))
        case selectMapMarkerData(Int)
        case bottomSheetScrollReachesBottom
        case regionSearchBottomSheetScrollReachesBottom
        
        case storeCellSelected(Int)
    }
    
    enum Mutation {
        case setFilter(String)
        case setMapMarkers([MapWithCategorySearchResponseResult])
        case setAroundDatas([AroundMapSearchResponseResultContent], isLast: Bool)
        case setAroundDatasAppend([AroundMapSearchResponseResultContent], isLast: Bool)
        
        case clearSearchMapDatas
        
        case setStoreSearchMarkerData(MapMarker?)
        case setStoreSearchInfoData(StoreInfo?)
        case setRegionSearchDatas([MapMarker])
        case setRegionAroundDatas([StoreInfo], regionId: Int, regionName: String, isLast: Bool)
        case setRegionAroundDatasAppend([StoreInfo], isLast: Bool)
        
        case setMapMarkerSelectData(StoreInfo)
    }
    
    struct State {
        
        @Pulse var mapMarkers: [MapWithCategorySearchResponseResult] = []
        var mapMarkerSelectData: StoreInfo? = nil
        var aroundDatas: [AroundMapSearchResponseResultContent] = []
        
        var mapCategoryFilters: [String]
        var mapFilterSelected: [String: Bool]
        
        // search
        var storeSearchMarker: MapMarker? = nil
        var storeSearchInfo: StoreInfo? = nil
        var regionSearchMarkerDatas: [MapMarker]? = nil
        var regionSearchAroundDatas: [StoreInfo] = []
        var searchRegionId: Int? = nil
        var searchRegionName: String? = nil
        var regionInfoIsLast: Bool = false
        var regionInfoPage: Int = 0
        
        var mapInfoIsLast: Bool = false
        var mapInfoPage: Int = 0
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    let categoryFilterList: [String] = ["bookmark"] + FashionCategory.List
    
    // 맵에 표시될 마커들을 캐싱
//    let markerCache = NSCacheManager<MapMarkerData>()
    
    var mapPosition: (Double, Double)? = nil
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(mapCategoryFilters: categoryFilterList,
                                  mapFilterSelected: Dictionary(uniqueKeysWithValues: categoryFilterList.map { (String($0), false) }))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonDidTap:
            guard let mapPosition else { return .empty()}
            steps.accept(AppStep.mapSearch(mapPosition))
            return .just(.clearSearchMapDatas)
            
        case .exitButtonDidTap:
            return .just(.clearSearchMapDatas)
            
        case .selectFilter(let filter):
            var filterDict = currentState.mapFilterSelected
            filterDict[filter]?.toggle()
            
            let selectedCategories = Array(filterDict.filter { $0.value == true }.keys)
            let mapDatas = provider.mapService.filterMap(data: CategoryMapFilterData(category: selectedCategories,
                                                                                     latitude: self.mapPosition?.0 ?? 0.0,
                                                                                     longitude: self.mapPosition?.1 ?? 0.0))
                .data().decode(type: MapWithCategorySearchResponse.self, decoder: JSONDecoder())
                .map { $0.result }
            
            return Observable.concat([
                mapDatas.flatMap { datas -> Observable<Mutation> in
                    return .just(.setMapMarkers(datas))
                },
                .just(.setFilter(filter))
            ])
            
        case .searchFieldDidTap:
            guard let mapPosition = mapPosition else { return .empty() }
            steps.accept(AppStep.mapSearch(mapPosition))
            return .empty()
            
        case .searchButtonDidTap:
            let selectedCategories = Array(currentState.mapFilterSelected.filter({ $0.value == true }).keys)
            let mapFilterData = CategoryMapFilterData(category: selectedCategories,
                                                      latitude: self.mapPosition?.0 ?? 0.0,
                                                      longitude: self.mapPosition?.1 ?? 0.0)
            return Observable.concat([
                provider.mapService.filterMap(data: mapFilterData).data()
                    .decode(type: MapWithCategorySearchResponse.self, decoder: JSONDecoder())
                    .flatMap { data -> Observable<Mutation> in
                        return .just(.setMapMarkers(data.result))
                    },
                provider.mapService.mapInfo(data: mapFilterData, page: 0, size: 10).data()
                    .decode(type: AroundMapSearchResponse.self, decoder: JSONDecoder())
                    .flatMap { result -> Observable<Mutation> in
                        if let contents = result.result?.contents, let isLast = result.result?.isLast {
                            return .just(.setAroundDatas(contents, isLast: isLast))
                        } else {
                            return .empty()
                        }
                    }
            ])
            
        case .bottomSheetScrollReachesBottom:
            if currentState.mapInfoIsLast {
                return .empty()
            } else {
                let selectedCategories = Array(currentState.mapFilterSelected.filter({ $0.value == true }).keys)
                let mapFilterData = CategoryMapFilterData(category: selectedCategories,
                                                          latitude: self.mapPosition?.0 ?? 0.0,
                                                          longitude: self.mapPosition?.1 ?? 0.0)
                return provider.mapService.mapInfo(data: mapFilterData, page: currentState.mapInfoPage, size: 10).data()
                    .decode(type: AroundMapSearchResponse.self, decoder: JSONDecoder())
                    .flatMap { result -> Observable<Mutation> in
                        if let contents = result.result?.contents, let isLast = result.result?.isLast {
                            return .just(.setAroundDatasAppend(contents, isLast: isLast))
                        } else {
                            return .empty()
                        }
                    }
            }
            
        case .regionSearchBottomSheetScrollReachesBottom:
            if currentState.regionInfoIsLast {
                return .empty()
            }
            return provider.mapService.searchMapInfoRegion(regionId: currentState.searchRegionId ?? 0, page: currentState.regionInfoPage, size: 10).data().decode(type: RegionAroundMapSearchResponse.self, decoder: JSONDecoder())
                .flatMap { result -> Observable<Mutation> in
                    return .just(.setRegionAroundDatasAppend(result.result.contents, isLast: result.result.isLast))
                }
            
        case .selectMapMarkerData(let storeId):
            return provider.mapService
                .mapInfoBottomSheet(storeId: storeId).data().decode(type: MapMarkerSelectResponse.self, decoder: JSONDecoder())
                .flatMap { data -> Observable<Mutation> in
                    return .just(.setMapMarkerSelectData(data.result))
                }
            
        case .mapViewCameraPositionDidChanged(let position):
            // TODO: - 추후 마커단위로 로드할 수 있게 개선
            self.mapPosition = position
            return .empty()
            
        case .storeCellSelected(let storeId):
            steps.accept(AppStep.showRoomDetail(storeId))
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge([mutation, provider.mapService.event.debug().flatMap { value -> Observable<Mutation> in
            switch value {
            case .store(let storeSearchData):
                switch storeSearchData {
                case.sheetData(let storeData):
                    return .just(.setStoreSearchInfoData(storeData))
                case .markerData(let markerData):
                    return .just(.setStoreSearchMarkerData(markerData))
                }
            case .region(let regionSearchData):
                switch regionSearchData {
                case .sheetDatas(let sheetData, let regionId, let regionName):
                    return .just(.setRegionAroundDatas(sheetData.contents, regionId: regionId, regionName: regionName, isLast: sheetData.isLast))
                case.markerDatas(let markerDatas):
                    return .just(.setRegionSearchDatas(markerDatas))
                }
            }
        }])
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            
        case .setFilter(let filter):
            state.mapFilterSelected[filter]?.toggle()
            
        case .setMapMarkers(let markers):
            state.mapMarkers = markers
            state.storeSearchMarker = nil
            state.regionSearchMarkerDatas = nil
            
        case .setStoreSearchMarkerData(let markerData):
            state.storeSearchMarker = markerData
            state.mapMarkers = []
            state.regionSearchMarkerDatas = nil
            
        case .setRegionSearchDatas(let datas):
            state.mapMarkers = []
            state.storeSearchMarker = nil
            state.regionSearchMarkerDatas = datas
            
        case .setAroundDatas(let datas, let isLast):
            state.aroundDatas = datas
            state.mapInfoIsLast = isLast
            state.mapInfoPage = 0
            if !isLast {
                state.mapInfoPage += 1
            }
            
        case .setAroundDatasAppend(let datas, let isLast):
            state.aroundDatas += datas
            state.mapInfoIsLast = isLast
            if !isLast {
                state.mapInfoPage += 1
            }
            
        case .setStoreSearchInfoData(let data):
            state.storeSearchInfo = data
            
        case .setRegionAroundDatas(let datas, let regionId, let regionName, let isLast):
            state.regionSearchAroundDatas = datas
            state.regionInfoPage = 0
            state.regionInfoIsLast = isLast
            state.searchRegionName = regionName
            state.searchRegionId = regionId
            if !isLast{
                state.regionInfoPage += 1
            }
            
        case .setRegionAroundDatasAppend(let datas, let isLast):
            state.regionSearchAroundDatas += datas
            state.regionInfoIsLast = isLast
            if !isLast {
                state.regionInfoPage += 1
            }
            
        case .setMapMarkerSelectData(let data):
            state.mapMarkerSelectData = data
            
        case .clearSearchMapDatas:
            state.storeSearchMarker = nil
            state.mapMarkerSelectData = nil
            state.regionSearchMarkerDatas = nil
            state.regionInfoIsLast = false
            state.mapInfoIsLast = false
            state.regionInfoPage = 0
            state.mapInfoPage = 0
            state.storeSearchInfo = nil
        }
        return state
    }
}
