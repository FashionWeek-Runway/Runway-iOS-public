//
//  MapSearchReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/01.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import RealmSwift
import Alamofire

final class MapSearchReactor: Reactor, Stepper {
    // MARK: - Events
    
    struct State {
        
        var searchHistories: [MapSearchHistory]? = nil
        var mapKeywordSearchData: [KeywordSearchItem] = []
        
        let mapLocation: (Double, Double)
    }
    
    enum Action {
        case viewDidLoad
        case backButtonDidtap
        case historyRemoveButtonDidTap(MapSearchHistory)
        case historyAllClearButtonDidTap
        case searchFieldInput(String)
        case selectSearchItem(Int)
        case selectHistoryItem(Int)
    }
    
    enum Mutation {
        case setSearchHistories([MapSearchHistory])
        case setMapKeywordSearchData([KeywordSearchItem])
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType, mapLocation: (Double, Double)) {
        self.provider = provider
        self.initialState = State(mapLocation: mapLocation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let histories = provider.realm?.objects(MapSearchHistory.self).sorted(byKeyPath: "date", ascending: false)
            var historyContainer = [MapSearchHistory]()
            histories?.forEach {
                historyContainer.append($0)
            }
            return Observable.concat([
                .just(.setSearchHistories(historyContainer))
            ])
            
        case .backButtonDidtap:
            steps.accept(AppStep.back(animated: false))
            return .empty()
            
        case .historyRemoveButtonDidTap(let history):
            do {
                try provider.realm?.write {
                    provider.realm?.delete(history)
                }
            } catch {
                print(error)
            }
            
            let histories = provider.realm?.objects(MapSearchHistory.self).sorted(byKeyPath: "date", ascending: false)
            var historyContainer = [MapSearchHistory]()
            histories?.forEach {
                historyContainer.append($0)
            }
            return .just(.setSearchHistories(historyContainer))
            
        case .historyAllClearButtonDidTap:
            do {
                try provider.realm?.write {
                    guard let histories = provider.realm?.objects(MapSearchHistory.self) else { return }
                    provider.realm?.delete(histories)
                }
            } catch {
                print(error)
            }
            
            return Observable.concat([
                .just(.setMapKeywordSearchData([])),
                .just(.setSearchHistories([]))
            ])
            
        case .searchFieldInput(let text):
            if text.isEmpty {
                return .just(.setMapKeywordSearchData([]))
            } else {
                return provider.mapService.mapSearch(data: MapSearchData(content: text,
                                                                         latitude: self.currentState.mapLocation.0,
                                                                         longitude: self.currentState.mapLocation.1)).data().decode(type: MapKeywordSearchResponse.self, decoder: JSONDecoder())
                    .flatMap { result -> Observable<Mutation> in
                        let datas = (result.result.regionSearchList + result.result.storeSearchList)
                        return datas.isEmpty ? .just(.setMapKeywordSearchData([])) : .just(.setMapKeywordSearchData(datas))
                    }
            }
            
        case .selectSearchItem(let index):
            let searchItem = currentState.mapKeywordSearchData[index]
            // 매장
            if let storeName = searchItem.storeName {
                let history = provider.realm?.objects(MapSearchHistory.self).where {
                    $0.name == storeName
                }.first
                if history == nil { // create
                    let newHistory = MapSearchHistory()
                    newHistory.name = storeName
                    newHistory.storeId = searchItem.storeID
                    newHistory.isStore = true
                    do {
                        try provider.realm?.write {
                            provider.realm?.create(MapSearchHistory.self, value: newHistory)
                        }
                    } catch {
                        print(error)
                    }
                } else { // update
                    do {
                        try provider.realm?.write {
                            history?.date = Date()
                        }
                    } catch {
                        print(error)
                    }
                }
            // 지역
            } else if let regionName = searchItem.region {
                let history = provider.realm?.objects(MapSearchHistory.self).where {
                    $0.name == regionName
                }.first
                if history == nil {
                    let newHistory = MapSearchHistory()
                    newHistory.name = regionName
                    newHistory.regionId = searchItem.regionID
                    newHistory.isStore = false
                    do {
                        try provider.realm?.write {
                            provider.realm?.create(MapSearchHistory.self, value: newHistory)
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    do {
                        try provider.realm?.write {
                            history?.date = Date()
                        }
                    } catch {
                        print(error)
                    }
                }
            } else { // error
                return .empty()
            }
            
            if let storeId = searchItem.storeID { // 매장검색
                searchStore(with: storeId)
            } else if let regionId = searchItem.regionID, let regionName = searchItem.region { // 지역검색
                searchRegion(with: regionId, regionName: regionName)
            }

            return .empty()
            
        case .selectHistoryItem(let index):
            guard let historyData = currentState.searchHistories?[index] else { return .empty() }
            // 매장
            let history = provider.realm?.objects(MapSearchHistory.self).where {
                $0.name == historyData.name
            }.first
            
            do {
                try provider.realm?.write {
                    history?.date = Date()
                }
            } catch {
                print(error)
            }
            
            if let storeId = historyData.storeId { // 매장검색
                searchStore(with: storeId)
            } else if let regionId = historyData.regionId { // 지역검색
                searchRegion(with: regionId, regionName: historyData.name)
            }

            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setSearchHistories(let histories):
            state.searchHistories = histories
            
        case .setMapKeywordSearchData(let datas):
            state.mapKeywordSearchData = datas
            
        }
        
        return state
    }
    
    private func searchStore(with storeId: Int) {
        provider.mapService.searchStore(storeId: storeId)
            .data().decode(type: StoreSearchResponse.self, decoder: JSONDecoder())
            .bind(onNext: { [weak self] result in
                self?.provider.mapService.event.accept(.store(.markerData(result.result.mapMarker)))
                self?.provider.mapService.event.accept(.store(.sheetData(result.result.storeInfo)))
                self?.steps.accept(AppStep.back(animated: false))
            }).disposed(by: disposeBag)
    }
    
    private func searchRegion(with regionId: Int, regionName: String) {
        
        provider.mapService.searchMapRegion(regionId: regionId)
            .data().decode(type: RegionSearchResponse.self, decoder: JSONDecoder())
            .bind(onNext: { [weak self] markerResult in
                guard let self else { return }
                
                self.provider.mapService.searchMapInfoRegion(regionId: regionId, page: 0, size: 10)
                    .data().decode(type: RegionAroundMapSearchResponse.self, decoder: JSONDecoder())
                    .subscribe(onNext: { result in
                        self.provider.mapService.event.accept(.region(.markerDatas(markerResult.result)))
                        self.provider.mapService.event.accept(.region(.sheetDatas(result.result, regionId, regionName)))
                        self.steps.accept(AppStep.back(animated: false))
                    }).disposed(by: self.disposeBag)
                
                
            }).disposed(by: disposeBag)
    }
}
