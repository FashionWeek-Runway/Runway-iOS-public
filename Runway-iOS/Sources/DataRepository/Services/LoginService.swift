//
//  LoginService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/08.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

final class LoginService: APIService {
    
    func login(password: String, phone: String) -> Observable<DataRequest> {
        
        var params = Parameters()
        params.updateValue(password, forKey: "password")
        params.updateValue(phone, forKey: "phone")
        
        return request(.post, "login", useAuthHeader: false, parameters: params)
    }
    
    func loginAsKakao(oAuthToken: String) -> Observable<DataRequest> {
        
        var params = Parameters()
        params.updateValue(oAuthToken, forKey: "accessToken")
        return request(.post, "login/kakao", useAuthHeader: false, parameters: params)
    }
    
    func loginAsApple(oAuthToken: String) -> Observable<DataRequest> {
        
        var params = Parameters()
        params.updateValue(oAuthToken, forKey: "accessToken")
        return request(.post, "login/apple", useAuthHeader: false, parameters: params)
    }
}
