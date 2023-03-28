//
//  PhoneCertificationReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/15.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class PhoneCertificationReactor: Reactor, Stepper {
    
    // MARK: - Events
    
    enum Action {
        case viewDidLoad
        case backButtonDidTap
        case verificationNumberInput(String)
        case resendButtonDidTap
        case confirmButtonDidTap

        case timer(Int)
    }
    
    enum Mutation {
        case setVerificationNumber(String)
        case setInvalidCertification
        case setTimeIntiailly
        case setTime
    }
    
    struct State{
        let phoneNumber: String
        var verificationNumber: String?
        var isRequestEnabled: Bool = false
        
        var invalidCertification = true
        
        var timerText: String? = nil
        var timeSecond = 180
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    let initialState: State
    let provider: ServiceProviderType
    let steps = PublishRelay<Step>()
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(phoneNumber: self.provider.signUpService.signUpAsPhoneData?.phone ?? "")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return provider.signUpService.sendVerificationMessage(phoneNumber: initialState.phoneNumber)
                .validate(statusCode: 200...299)
                .flatMap({ _ -> Observable<Mutation> in
                    return .empty()
                })
            //        case .setTimer(let string):
            //            return .just(.setTimerText(string))
        case .timer(_):
            return .just(.setTime)
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .verificationNumberInput(let string):
            return .just(.setVerificationNumber(string))
        case .resendButtonDidTap:
            steps.accept(AppStep.toast("인증번호를 다시 보냈습니다."))
            return Observable.concat([
                provider.signUpService.sendVerificationMessage(phoneNumber: initialState.phoneNumber)
                    .validate(statusCode: 200...299)
                    .flatMap({ _ -> Observable<Mutation> in
                        return .empty()
                    }),
                Observable.just(Mutation.setTimeIntiailly)
            ])
        case .confirmButtonDidTap:
            guard let number = currentState.verificationNumber else { return .empty() }
            return provider.signUpService.checkVerificationNumber(verificationNumber: number,
                                                                  phoneNumber: initialState.phoneNumber).responseData()
                .flatMap { [weak self] (response, data) -> Observable<Mutation> in
                    if 200...299 ~= response.statusCode {
                        self?.steps.accept(AppStep.passwordInputRequired)
                        return .empty()
                    } else {
                        return .just(.setInvalidCertification)
                    }
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setVerificationNumber(let string):
            state.invalidCertification = false
            state.verificationNumber = String.limitedLengthString(string, length: 6)
        case .setInvalidCertification:
            state.invalidCertification = true
        case .setTimeIntiailly:
            state.timeSecond = 180
        case .setTime:
            state.timeSecond -= 1
            if state.timeSecond <= 0 {
                // TODO: - 시간 만료시 해야할 동작
                state.timeSecond = 0
            }
            state.timerText = formattedTimerText(timeSecond: state.timeSecond)
        }
        state.isRequestEnabled = state.verificationNumber?.count == 6
        return state
    }
    
    private func formattedTimerText(timeSecond: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter.string(from: TimeInterval(timeSecond)) ?? "0:00"
    }
}
