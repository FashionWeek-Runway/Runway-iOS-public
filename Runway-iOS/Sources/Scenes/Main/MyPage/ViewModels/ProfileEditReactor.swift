//
//  ProfileEditReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/03/09.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

import Alamofire
import RxAlamofire

import Kingfisher

final class ProfileEditReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewWillAppear
        case backButtonDidTap
        case setProfileImage(Data?)
        case enterNickname(String)
        case saveButtonDidTap
    }
    
    enum Mutation {
        case setProfileImageData(Data?)
        case setProfileImageURL(String?)
        case setOriginalNickname(String?)
        case setUserNickname(String?)
        case setUserNicknameIsDuplicate
    }
    
    struct State {
        var profileImageURL: String? = nil
        var showActionSheet: Bool = false
        
        var originalNickname: String?
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
        let state = State()
        self.initialState = state
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return provider.userService.existingProfile().data()
                .decode(type: ExistingProfileResponse.self, decoder: JSONDecoder())
                .flatMap { responseData -> Observable<Mutation> in
                    print(responseData)
                    return Observable.concat([
                        .just(.setProfileImageURL(responseData.result.imageURL ?? nil)),
                        .just(.setUserNickname(responseData.result.nickname)),
                        .just(.setOriginalNickname(responseData.result.nickname))
                    ])
                }
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
            
        case .setProfileImage(let data):
            return .just(.setProfileImageData(data))
        case .enterNickname(let nickname):
            return .just(.setUserNickname(nickname))
        case .saveButtonDidTap:
            guard let nickname = currentState.nickname else { return .empty() }
            
            if nickname != currentState.originalNickname {
                return provider.signUpService.checkNicknameDuplicate(nickname: nickname).responseData()
                    .flatMap { [weak self] (response, data) -> Observable<Mutation> in
                        guard let self else { return .empty() }
                        if 200...299 ~= response.statusCode {
                            return self.editProfile()
                        } else {
                            return .just(.setUserNicknameIsDuplicate)
                        }
                    }
            } else {
                return editProfile()
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.isNickNameDuplicate = false
        
        switch mutation {
        case .setUserNickname(let nickname): // nickname validation
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
        case .setOriginalNickname(let nickname):
            state.originalNickname = nickname
        case .setProfileImageURL(let url):
            state.profileImageURL = url
        case .setProfileImageData(let data):
            state.profileImageData = data
            state.showActionSheet = false
        case .setUserNicknameIsDuplicate:
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
    
    private func editProfile() -> Observable<Mutation> {
        guard let nickname = currentState.nickname else { return .empty() }
        
        if let profileImageData = self.currentState.profileImageData {
            return self.provider.userService.editProfile(nickname: nickname,
                                                  profileImageChange: true,
                                                  profileImageData: profileImageData).flatMap { [weak self] request in
                return request.rx.data().decode(type: ProfileEditCompleteResponse.self, decoder: JSONDecoder())
                    .flatMap { [weak self] responseData -> Observable<Mutation> in
                        self?.steps.accept(AppStep.profileEditCompleted(responseData.result.nickname, responseData.result.categoryList, responseData.result.imageURL))
                        return .empty()
                    }
            }
        } else {
            return self.provider.userService.editProfile(nickname: nickname,
                                                  profileImageChange: false,
                                                  profileImageData: nil).flatMap { [weak self] request in
                return request.rx.data().decode(type: ProfileEditCompleteResponse.self, decoder: JSONDecoder())
                    .flatMap { [weak self] responseData -> Observable<Mutation> in
                        self?.steps.accept(AppStep.profileEditCompleted(responseData.result.nickname, responseData.result.categoryList, responseData.result.imageURL))
                        return .empty()
                    }
            }
        }
    }
}
