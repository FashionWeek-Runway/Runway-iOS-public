//
//  HeaderInjector.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/07.
//

import Alamofire

protocol HeaderInterceptor {
    func intercept(headers: inout HTTPHeaders)
}
