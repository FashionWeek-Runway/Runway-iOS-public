//
//  ProfileSettingReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class ProfileSettingReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case backButtonDidTap
        case setProfileImage(Data?)
        case enterNickname(String)
        case nextButtonDidTap
    }
    
    enum Mutation {
        case setProfileImageData(Data?)
        case setNickname(String?)
        case setNickNameDuplicate
    }
    
    struct State {
        var profileImageURL: String?
        
        var showActionSheet: Bool = false
        
        var nickname: String?
        var profileImageData: Data?
        var nextButtonEnabled: Bool = false
        
        var isNickNameDuplicate = false
        var isNickNameValidate = true
    }
    
    // MARK: - Properties
    
    var steps = PublishRelay<Step>()
    
    let initialState: State
    let provider: ServiceProviderType
    
    private let disposeBag = DisposeBag()
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType) {
        let state = State(profileImageURL: provider.signUpService.signUpAsKakaoData?.profileImageURL ?? provider.signUpService.signUpAsAppleData?.profileImageURL)
        self.initialState = state
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            if let urlString = initialState.profileImageURL, // 이미지 URL이 있는 경우
               let url = URL(string: urlString) {
                let imageLoadMutation = URLSession.shared.rx.data(request: URLRequest(url: url))
                    .map { data in
                        return Mutation.setProfileImageData(data)
                    }
                return imageLoadMutation
            } else {
                return .just(.setProfileImageData(nil))
            }
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .setProfileImage(let data):
            return .just(.setProfileImageData(data))
        case .enterNickname(let nickname):
            return .just(.setNickname(nickname))
        case .nextButtonDidTap:
            guard let nickname = currentState.nickname else { return .empty() }
            
            provider.signUpService.signUpAsPhoneData?.profileImageData = currentState.profileImageData
            provider.signUpService.signUpAsPhoneData?.nickname = nickname
            provider.signUpService.signUpAsKakaoData?.profileImageData = currentState.profileImageData
            provider.signUpService.signUpAsKakaoData?.nickname = nickname
            provider.signUpService.signUpAsAppleData?.profileImageData = currentState.profileImageData
            provider.signUpService.signUpAsAppleData?.nickname = nickname
            
            return provider.signUpService.checkNicknameDuplicate(nickname: nickname).response()
                .flatMap { response -> Observable<Mutation> in
                    if 200...299 ~= response.statusCode {
                        self.steps.accept(AppStep.categorySettingIsRequired)
                        return .empty()
                    } else {
                        return .just(.setNickNameDuplicate)
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.isNickNameDuplicate = false
        
        switch mutation {
        case .setNickname(let nickname): // nickname validation
            state.nickname = limitedLengthNickname(nickname ?? "")
            if let nickname = nickname {
                if nickname == "" {
                    state.nextButtonEnabled = false
                    state.isNickNameValidate = false
                }
                
                do {
                    let regex = try NSRegularExpression(pattern: "^[a-zA-Z가-힣]{2,10}$")
                    let range = NSRange(location: 0, length: nickname.utf16.count)
                    state.nextButtonEnabled = regex.firstMatch(in: nickname, range: range) != nil
                } catch let error {
                    print("Invalid regex", error)
                }
            } else {
                state.nextButtonEnabled = false
            }
            
            if let nickname = nickname {
                if nickname.count == 0 {
                    state.isNickNameValidate = false
                } else {
                    do {
                        let regex = try NSRegularExpression(pattern: "^[a-zA-Z가-힣]{2,10}$")
                        let range = NSRange(location: 0, length: nickname.utf16.count)
                        state.isNickNameValidate = regex.firstMatch(in: nickname, range: range) == nil
                    } catch let error {
                        print("Invalid regex", error)
                    }
                }
            } else {
                state.isNickNameValidate = true
            }
        case .setProfileImageData(let data):
            state.profileImageData = data
            state.showActionSheet = false
        case .setNickNameDuplicate:
            state.isNickNameDuplicate = true
        }
        
        return state
    }
    
    private func limitedLengthNickname(_ str: String) -> String { // 최대 10글자 까지
        if str.count > 10 {
            let index = str.index(str.startIndex, offsetBy: 10)
            return String(str[..<index])
        } else {
            return str
        }
    }
}
