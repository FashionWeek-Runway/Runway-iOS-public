//
//  Reactive+.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/07.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in }
    }
    
    var viewWillAppear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in }
    }
    
    var viewDidAppear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { _ in }
    }
    
    var viewWillDisappear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { _ in }
    }
    
    var viewDidDisappear: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { _ in }
    }
}
