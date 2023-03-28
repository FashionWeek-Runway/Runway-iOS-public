//
//  ForgotPasswordPhoneCertificationNumberInputReactor.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/16.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import ReactorKit

final class ForgotPasswordPhoneCertificationNumberInputReactor: Reactor, Stepper {
    
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
        case setTimerText(String)
        
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
    
    private var timeSecond = 0
    private var timerText = ""
    var timer: Timer?
    
    // MARK: - initializer
    
    init(provider: ServiceProviderType, phoneNumber: String) {
        self.provider = provider
        self.initialState = State(phoneNumber: phoneNumber)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            provider.signUpService.sendVerificationMessage(phoneNumber: initialState.phoneNumber).responseData()
                .subscribe()
                .disposed(by: disposeBag)
            return .empty()
        case .timer(let string):
            return .just(.setTime)
        case .backButtonDidTap:
            steps.accept(AppStep.back(animated: true))
            return .empty()
        case .verificationNumberInput(let string):
            return .just(.setVerificationNumber(string))
        case .resendButtonDidTap:
            steps.accept(AppStep.toast("인증번호를 다시 보냈습니다."))
            return Observable.concat([
                provider.signUpService.sendVerificationMessage(phoneNumber: initialState.phoneNumber).responseData()
                    .flatMap({ (response, data) -> Observable<Mutation> in
                        if 200...299 ~= response.statusCode {
                            return .empty()
                        } else {
                            return .empty()
                        }
                    }),
                Observable.just(.setTimeIntiailly)
            ])
        case .confirmButtonDidTap:
            guard let number = currentState.verificationNumber else { return .empty() }
            return provider.signUpService.checkVerificationNumber(verificationNumber: number,
                                                           phoneNumber: initialState.phoneNumber).responseData()
                .flatMap { [weak self] (response, data) -> Observable<Mutation> in
                    if 200...299 ~= response.statusCode {
                        guard let phoneNumber = self?.initialState.phoneNumber else { return .empty() }
                        self?.steps.accept(AppStep.newPasswordInputRequired(phoneNumber))
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
        case .setTimerText(let timerText):
            state.timerText = timerText
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

