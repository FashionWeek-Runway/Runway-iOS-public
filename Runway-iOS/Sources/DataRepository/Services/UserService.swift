//
//  UserService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

final class UserService: APIService, AuthTokenHost {
    
    func mypageInformation() -> Observable<DataRequest> {
        return request(.get, "users/")
    }
    
    func bookmarkReviewList(page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "users/bookmark/review", parameters: params, encoding: URLEncoding.default)
    }
    
    func bookmarkReviewDetail(reviewId: Int) -> Observable<DataRequest> {
        return request(.get, "users/bookmark/review/detail/\(reviewId)")
    }
    
    func privacyInformation() -> Observable<DataRequest> {
        return request(.get, "users/info")
    }
    
    func linkWithApple(socialToken: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(socialToken, forKey: "accessToken")
        return request(.post, "users/info/apple", parameters: params)
    }
    
    func unlinkWithApple(authorizationCode: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(authorizationCode, forKey: "code")
        return request(.delete, "users/info/apple", parameters: params)
    }
    
    func linkWithKakao(socialToken: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(socialToken, forKey: "accessToken")
        return request(.post, "users/info/kakao", parameters: params)
    }
    
    func unlinkWithKakao() -> Observable<DataRequest> {
        return request(.delete, "users/info/kakao")
    }
    
    func existingProfile() -> Observable<DataRequest> {
        return request(.get, "users/profile")
    }
    
    func editProfile(nickname: String, profileImageChange: Bool, profileImageData: Data?) -> Observable<UploadRequest> {
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "accept": "application/json", "X-AUTH-TOKEN": authToken]
        
        var params = Parameters()
        params.updateValue(nickname, forKey: "nickname")
        params.updateValue(profileImageChange ? 0 : 1, forKey: "basic")
        
        return self.session.rx.upload(multipartFormData: { data in
            for (key, value) in params {
                data.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let profileImageData = profileImageData {
                data.append(profileImageData, withName: "multipartFile",
                            fileName: nickname + ".png",
                            mimeType: "image/png")
            }
        }, to: baseURL + "users/profile", method: .patch, headers: headers)
    }
    
    func checkOriginalPassword(password: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(password, forKey: "password")
        return request(.post, "users/password", parameters: params)
    }
    
    func changePassword(password: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(password, forKey: "password")
        return request(.patch, "users/password", parameters: params)
    }
    
    func myReview(page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "users/review", parameters: params, encoding: URLEncoding.default)
    }
    
    func myReviewDetail(reviewId: Int) -> Observable<DataRequest> {
        return request(.get, "users/review/detail/\(reviewId)")
    }
    
    func bookmarkShowRooms(page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "users/store", parameters: params, encoding: URLEncoding.default)
    }
    
    
    func setUserLocation(latitude: Float, longitude: Float) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(latitude, forKey: "latitude")
        params.updateValue(longitude, forKey: "longitude")
        return request(.post, "users/location", parameters: params)
    }
    
    func logout() -> Observable<DataRequest> {
        return request(.get, "users/logout")
    }
    
    func refresh() -> Observable<DataRequest> {
        return request(.post, "users/refresh")
    }
    
    func withdrawUser() -> Observable<DataRequest> {
        return request(.patch, "users/active")
    }
    
    func withdrawAppleUser(authorizationCode: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(authorizationCode, forKey: "code")
        return request(.patch, "users/apple/active", parameters: params)
    }
    
}
