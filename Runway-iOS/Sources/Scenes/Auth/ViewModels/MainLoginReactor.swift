//
//  MainLoginReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/10.
//

import Foundation

import ReactorKit
import RxFlow
import RxSwift
import RxCocoa

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

import Alamofire

enum LoginError: Error {
    case notRegistered
    case serverError
}

final class MainLoginReactor: Reactor, Stepper {
    // MARK: - Events
    
    struct State {
    }
    
    enum Action {
        case kakaoLoginButtonDidTap
        case appleLoginButtonDidTap
        case phoneLoginButtonDidTap
        
        case requestkakaoLogin
        case requestAppleLogin
    }
    
    enum Mutation {
        case setKakaoLogin
        case setAppleLogin
        case setPhoneLogin
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .kakaoLoginButtonDidTap:
            provider.signUpService.signUpAsKakaoData = SignUpAsKakaoData()
            if UserApi.isKakaoTalkLoginAvailable() {
                return UserApi.shared.rx.loginWithKakaoTalk()
                    .flatMap { [weak self] token -> Observable<Mutation> in
                        self?.provider.appSettingService.kakaoAccessToken = token.accessToken
                        self?.loginKakao(kakaoOauthToken: token.accessToken)
                        return .empty()
                    }.catch { error in
                        print(error as NSError)
                        return .empty()
                    }
            }
            else {
                return UserApi.shared.rx.loginWithKakaoAccount()
                    .flatMap { [weak self] token -> Observable<Mutation> in
                        self?.provider.appSettingService.kakaoAccessToken = token.accessToken
                        self?.loginKakao(kakaoOauthToken: token.accessToken)
                        return .empty()
                    }
            }
        case .appleLoginButtonDidTap:
            provider.signUpService.signUpAsAppleData = SignUpAsAppleData()
            provider.appleLoginService.login(with: [.fullName, .email]) { loginResult, error in
                if let error = error {
                    print(error)
                }

                guard let identityToken = loginResult?.identityToken,
                      let oauthToken = String(data: identityToken, encoding: .utf8) else { return }
                self.provider.loginService.loginAsApple(oAuthToken: oauthToken).validate(statusCode: 200...299).data().decode(type: AppleLoginResponse.self, decoder: JSONDecoder())
                    .subscribe(onNext: { [weak self] response in
                        if response.result.checkUser {
                            guard let authToken = response.result.accessToken,
                                  let refreshToken = response.result.refreshToken else { return }
                            self?.provider.appSettingService.authToken = authToken
                            self?.provider.appSettingService.refreshToken = refreshToken
                            self?.provider.appSettingService.isLoggedIn = true
                            self?.provider.appSettingService.lastLoginType = .apple
                            self?.steps.accept(AppStep.userIsLoggedIn)
                        } else {
                            self?.provider.signUpService.signUpAsAppleData?.socialID = response.result.appleID
                            self?.steps.accept(AppStep.profileSettingIsRequired)
                        }
                    })
                    .disposed(by: self.disposeBag)
            }
            return .empty()
            
        case .phoneLoginButtonDidTap:
            provider.signUpService.signUpAsPhoneData = SignUpAsPhoneData()
            steps.accept(AppStep.phoneNumberLogin)
            return .just(.setPhoneLogin)
        case .requestkakaoLogin:
            return .empty()
        case .requestAppleLogin:
            // TODO: -
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
    
    private func loginKakao(kakaoOauthToken: String) {
        return provider.loginService.loginAsKakao(oAuthToken: kakaoOauthToken) // 서버에서 400으로 데이터를 주기때문에...
            .responseData()
            .subscribe(onNext: { [weak self] (response, data) in
                if response.statusCode == 400 {
                    do {
                        let responseData = try JSONDecoder().decode(LoginAsKakaoResponse.self, from: data)
                        self?.provider.signUpService.signUpAsKakaoData?.profileImageURL = responseData.result.profileImageURL
                        self?.provider.signUpService.signUpAsKakaoData?.socialID = responseData.result.kakaoID
                        self?.steps.accept(AppStep.profileSettingIsRequired)
                    } catch {
                        print(error)
                    }
                } else {
                    do {
                        let responseData = try JSONDecoder().decode(SocialSignUpResponse.self, from: data)
                        self?.provider.appSettingService.isLoggedIn = true
                        self?.provider.appSettingService.authToken = responseData.result.accessToken
                        self?.provider.appSettingService.refreshToken = responseData.result.refreshToken
                        self?.provider.appSettingService.lastLoginType = .kakao
                        self?.steps.accept(AppStep.userIsLoggedIn)
                    } catch {
                        print(data)
                        print(error)
                    }
                }
            }).disposed(by: disposeBag)
    }
}
