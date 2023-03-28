//
//  DataRepository.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation
import RxSwift
import Alamofire
import Realm
import RealmSwift

protocol ServiceProviderType {
    var backgroundScheduler: ConcurrentDispatchQueueScheduler { get }
    
    var realm: Realm? { get }
    var appSettingService: AppSettingService { get }
    var networkManager: NetworkReachabilityManager? { get }
    var loginService: LoginService { get }
    var signUpService: SignUpService { get }
    var appleLoginService: AppleService { get }
    
    var userService: UserService { get }
    var showRoomService: ShowRoomService { get }
    var homeService: HomeService { get }
    var mapService: MapService { get }
}

final class DataRepository: ServiceProviderType {
    static let shared = DataRepository()
    
    let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    
    private init() {
        self.disposeBag = DisposeBag()
    }
    
    var disposeBag: DisposeBag
    
    // MARK: - App Setting Service (UserDefaults Value)
    
    lazy var appSettingService: AppSettingService = AppSettingService.shared
    
    // MARK: - Realm
    
    lazy var realm: Realm? = {
        var realmConfig = Realm.Configuration.defaultConfiguration
        realmConfig.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = realmConfig
        return try? Realm()
    }()
    
    // MARK: - Network Manager
    
    lazy var networkManager: NetworkReachabilityManager? = {
        let manager = NetworkReachabilityManager(host: "https://www.google.com/")
        manager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .reachable(_):
                // TODO:
                break
            default:
                break
            }
        })
        return manager
    }()
    
    // MARK: - API Services
    
    lazy var loginService: LoginService = LoginService(baseURL: APIServiceURL.RUNWAY_BASEURL, isLogging: true)
    
    lazy var signUpService: SignUpService = SignUpService(baseURL: APIServiceURL.RUNWAY_BASEURL, isLogging: true)
    
    lazy var appleLoginService: AppleService = AppleService.shared
    
    lazy var userService: UserService = UserService(baseURL: APIServiceURL.RUNWAY_BASEURL, isLogging: true)
    
    lazy var showRoomService: ShowRoomService = ShowRoomService(baseURL: APIServiceURL.RUNWAY_BASEURL, isLogging: true)
    
    lazy var homeService: HomeService = HomeService(baseURL: APIServiceURL.RUNWAY_BASEURL, isLogging: true)
    
    lazy var mapService: MapService = MapService(baseURL: APIServiceURL.RUNWAY_BASEURL, isLogging: true)
}
