//
//  AppleLoginService.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import Foundation
import AuthenticationServices

struct AppleLoginResult {
    let user: String
    let email: String?
    let fullName: String?
    let identityToken: Data?
    let authorizationCode: Data?
}
// TODO: - Rx로 바꿔야 함
final class AppleService: NSObject {
    
    static let shared = AppleService()
    
    var appleLoginResult: AppleLoginResult? = nil
    
    var completion: ((AppleLoginResult?, Error?) -> Void)? = nil
    
    override init() {
        super.init()
    }
    
    func login(with scopes: [ASAuthorization.Scope]?, completion: @escaping (AppleLoginResult?, Error?) -> Void) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = scopes
        self.completion = completion
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppleService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let nameFormatter = PersonNameComponentsFormatter()
            let fullName = appleIDCredential.fullName.flatMap { nameFormatter.string(from: $0) }
            let result = AppleLoginResult(user: appleIDCredential.user,
                                          email: appleIDCredential.email,
                                          fullName: fullName,
                                          identityToken: appleIDCredential.identityToken,
                                          authorizationCode: appleIDCredential.authorizationCode)
            
            appleLoginResult = result
            completion?(result, nil)
            completion = nil
            
            break
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(nil, error)
    }
}
