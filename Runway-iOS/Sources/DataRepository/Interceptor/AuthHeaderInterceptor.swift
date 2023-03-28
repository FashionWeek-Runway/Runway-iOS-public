//
//  AuthInterceptor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/07.
//

import Alamofire

class AuthHeaderInterceptor: HeaderInterceptor, AuthTokenHost {
    func intercept(headers: inout HTTPHeaders) {
        if authToken != "" {
            headers.add(name: "X-AUTH-TOKEN", value: authToken)
        }
    }
}
