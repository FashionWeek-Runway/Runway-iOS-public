////
////  RWAroundCollectionViewCellReactor.swift
////  Runway-iOS
////
////  Created by 김인환 on 2023/02/25.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//import ReactorKit
//import RxAlamofire
//
//final class RWAroundCollectionViewCellReactor: Reactor {
//    // MARK: Events
//    
//    enum Action {
//        case imageUrlSet(String)
//    }
//
//    enum Mutation {
//        case setCellImageData(Data?)
//    }
//
//    struct State {
//        var cellImageData: Data? = nil
//    }
//
//    let initialState: State = State()
//
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .imageUrlSet(let urlString):
//            return RxAlamofire.request(.get, urlString).data().flatMap { data -> Observable<Mutation> in
//                return .just(.setCellImageData(data))
//            }
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        var state = state
//        switch mutation {
//        case .setCellImageData(let data):
//            state.cellImageData = data
//        }
//        return state
//    }
//}
