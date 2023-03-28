//
//  Reactive+NMFMapView.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation
import RxSwift
import RxCocoa
import NMapsMap

//extension Reactive where Base: NMFMapView {
//    var touchDelegate: DelegateProxy<NMFMapView, NMFMapViewTouchDelegate> {
//        return RxNMFMapViewTouchDelegateProxy.proxy(for: self.base)
//    }
//
//    var cameraDelegate: DelegateProxy<NMFMapView, NMFMapViewCameraDelegate> {
//        return
//    }
//
//    ///  지도 탭 되면 호출되는 메서드
//    var didTapMap: Observable<(NMGLatLng, CGPoint)> {
//        return touchDelegate.methodInvoked(#selector(NMFMapViewTouchDelegate.mapView(_:didTapMap:point:))).map {
//            return (try castOrThrow(NMGLatLng.self, $0[1]), try castOrThrow(CGPoint.self, $0[2]))
//        }
//    }
//
//    /// 지도 심볼이 탭되면 호출되는 메서드
//    var didTap: Observable<NMFSymbol> {
//        return touchDelegate.methodInvoked(#selector(NMFMapViewTouchDelegate.mapView(_:didTap:))).map {
//            return try castOrThrow(NMFSymbol.self, $0[1])
//        }
//    }
//}
//
//fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
//    guard let returnValue = object as? T else {
//        throw RxCocoaError.castingError(object: object, targetType: resultType)
//    }
//    return returnValue
//}
