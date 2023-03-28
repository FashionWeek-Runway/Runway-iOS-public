//
//  IdentityVerificationReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation

import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class IdentityVerificationReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case backButtonDidTap
        case nameInput(String)
        case isForeignInput(Bool)
        case genderInput(String)
        case birthDayInput(String)
        case mobileCarrierInput(String)
        case phoneNumberInput(String)
        case requestButtonDidTap
        
        case userAgeIsUnderFourteen
        
        case isDuplicatePhoneNumber
    }
    
    enum Mutation {
        case setName(String)
        case setIsForeign(Bool)
        case setGender(String)
        case setBirthDay(String)
        case setMobileCarrier(String)
        case setPhoneNumber(String)
        case setShouldDuplicateLabel
    }
    
    struct State{
        var name: String? = nil
        var isForeign: Bool = false
        var gender: String? = nil
        var birthDay: String? = nil
        var mobileCarrier: String? = "SKT"
        var phoneNumber: String? = nil
        
        var isMessageRequestEnabled: Bool = false
        
        var shouldShowDuplicateError: Bool = false
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    // MARK: - intializer
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .nameInput(let name):
            return .just(.setName(name))
        case .isForeignInput(let isForeign):
            return .just(.setIsForeign(isForeign))
        case .genderInput(let gender):
            return .just(.setGender(gender))
        case .birthDayInput(let birthDay):
            return .just(.setBirthDay(birthDay))
        case .mobileCarrierInput(let mobileCarrier):
            return .just(.setMobileCarrier(mobileCarrier))
        case .phoneNumberInput(let phoneNumber):
            return .just(.setPhoneNumber(phoneNumber))
        case .isDuplicatePhoneNumber:
            return .just(.setShouldDuplicateLabel)
        case .requestButtonDidTap:
            guard let phoneNumber = currentState.phoneNumber else { return .empty() }
            
            provider.signUpService.checkPhoneNumberDuplicate(phoneNumber: phoneNumber).responseData()
                .subscribe(onNext: { [weak self] response, data in
                    
                    if response.statusCode >= 400 {
                        self?.action.onNext(.isDuplicatePhoneNumber)
                    } else {
                        guard let gender = self?.currentState.gender,
                              let name = self?.currentState.name,
                              let phone = self?.currentState.phoneNumber else { return }
                        
                        self?.provider.signUpService.signUpAsPhoneData?.gender = gender
                        self?.provider.signUpService.signUpAsPhoneData?.name = name
                        self?.provider.signUpService.signUpAsPhoneData?.phone = phone
                        self?.steps.accept(AppStep.phoneCertificationNumberIsRequired)
                    }
            }).disposed(by: disposeBag)
        case .userAgeIsUnderFourteen:
            self.steps.accept(AppStep.loginRequired)
            return .empty()
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.shouldShowDuplicateError = false
        switch mutation {
        case .setName(let name):
            state.name = name
        case .setIsForeign(let isForeign):
            state.isForeign = isForeign
        case .setGender(let gender):
            state.gender = state.gender != gender ? gender : nil
        case .setBirthDay(let birthDay):
            state.birthDay = limitedLengthString(birthDay, length: 8)
        case .setMobileCarrier(let mobileCarrier):
            state.mobileCarrier = mobileCarrier
        case .setPhoneNumber(let phoneNumber):
            state.phoneNumber = limitedLengthString(phoneNumber, length: 11)
        case .setShouldDuplicateLabel:
            state.shouldShowDuplicateError = true
        }
        
        state.isMessageRequestEnabled = canRequest()
        return state
    }
    
    private func canRequest() -> Bool {
        guard let name = currentState.name,
              let gender = currentState.gender,
              let birthDay = currentState.birthDay,
              let mobileCarrier = currentState.mobileCarrier,
              let phoneNumber = currentState.phoneNumber else { return false }
        
        if !name.isEmpty
            && !gender.isEmpty
            && birthDay.count == 8
            && !mobileCarrier.isEmpty
            && 8...12 ~= phoneNumber.count {
            return true
        } else {
            return false
        }
    }
    
    private func limitedLengthString(_ str: String, length: Int) -> String { // limit
        if str.count > length {
            let index = str.index(str.startIndex, offsetBy: length)
            return String(str[..<index])
        } else {
            return str
        }
    }
}
