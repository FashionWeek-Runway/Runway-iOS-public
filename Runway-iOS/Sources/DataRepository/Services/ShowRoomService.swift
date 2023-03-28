//
//  ShowRoomService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/20.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

final class ShowRoomService: APIService, AuthTokenHost {
    
    func stores() -> Observable<DataRequest> {
        return request(.get, "stores")
    }
    
    func storeBookmark(storeId: Int) -> Observable<DataRequest> {
        return request(.post, "stores/\(storeId)")
    }
    
    func storeBlogs(storeId: Int, storeName: String) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(storeName, forKey: "storeName")
        return request(.get, "stores/blog/\(storeId)", parameters: params, encoding: URLEncoding.default)
    }
    
    func storeBoards(storeId: Int, page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "stores/board/\(storeId)", parameters: params, encoding: URLEncoding.default)
    }
    
    func storeDetail(storeId: Int) -> Observable<DataRequest> {
        return request(.get, "stores/detail/\(storeId)")
    }
    
    func storeReview(storeId: Int, page: Int, size: Int) -> Observable<DataRequest> {
        var params = Parameters()
        params.updateValue(page, forKey: "page")
        params.updateValue(size, forKey: "size")
        return request(.get, "stores/review/\(storeId)", parameters: params, encoding: URLEncoding.default)
    }
    
    func storeReview(storeId: Int, imageData: Data) -> Observable<UploadRequest> {
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data", "accept": "application/json", "X-AUTH-TOKEN": authToken]
        
        return self.session.rx.upload(multipartFormData: { data in
            data.append(imageData,
                        withName: "img",
                        fileName: "\(UUID(uuidString: String(storeId)))" + ".jpg",
                        mimeType: "image/jpeg")
        }, to: baseURL + "stores/review/img/\(storeId)", method: .post, headers: headers)
    }
    
    func reviewDetail(reviewId: Int) -> Observable<DataRequest> {
        return request(.get, "stores/review/detail/\(reviewId)")
    }
    
    func reviewBookmark(reviewId: Int) -> Observable<DataRequest> {
        return request(.post, "stores/review/bookmark/\(reviewId)")
    }
    
    func removeReview(reviewId: Int) -> Observable<DataRequest> {
        return request(.patch, "stores/review/detail/\(reviewId)")
    }
}
