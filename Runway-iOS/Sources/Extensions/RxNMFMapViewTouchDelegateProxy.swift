//
//  RxNMFMapViewTouchDelegateProxy.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation
import RxSwift
import RxCocoa
import NMapsMap

final class RxNMFMapViewTouchDelegateProxy: DelegateProxy<NMFMapView, NMFMapViewTouchDelegate>,
                                            DelegateProxyType,
                                            NMFMapViewTouchDelegate
{
    static func registerKnownImplementations() {
        self.register { mapView -> RxNMFMapViewTouchDelegateProxy in
            RxNMFMapViewTouchDelegateProxy(parentObject: mapView, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: NMFMapView) -> NMFMapViewTouchDelegate? {
        return object.touchDelegate
    }
    
    static func setCurrentDelegate(_ delegate: NMFMapViewTouchDelegate?, to object: NMFMapView) {
        object.touchDelegate = delegate
    }
}
