//
//  AppStep.swift
//  Runway-iOS
//
//  Created by 김인환 on 2023/02/09.
//

import Foundation
import RxFlow

enum AppStep: Step {
    
    // Global
    case alert(String, String, [String], (UIAlertAction) -> Void)
    case dismiss
    case toast(String)
    
    case back(animated: Bool)
    
    // Login
    case loginRequired
    case userIsLoggedIn
    
    case phoneNumberLogin
    case forgotPassword
    case forgotPasswordCertificationIsRequired(String)
    case newPasswordInputRequired(String)
    case userChangedPassword
    
    // Sign Up
    case identityVerificationIsRequired
    case phoneCertificationNumberIsRequired
    case passwordInputRequired
    case policyAgreementIsRequired
    
    case usagePolicyDetailNeedToShow
    case privacyPolicyDetailNeedToShow
    case locationPolicyDetailNeedToShow
    case marketingPolicyDetailNeedToShow
    
    case profileSettingIsRequired
    case categorySettingIsRequired
    case signUpIsCompleted(nickname: String, styles: [String], imageURL: String?)
    
    // Main
    case homeTab
    case categorySelect(String)
    case showAllStore
    
    case mapTab
    case mapSearch((Double, Double))
    case showRoomDetail(Int)
    case editReviewImage(Int, Data)
    case reportReview(Int)
    
    
    case myPageTab
    case editProfile
    case setting
    case privacyManagementNeeded
    case passwordChange
    case newPasswordInput
    case userPasswordChanged
    case profileEditCompleted(String, [String], String?)
    case confirmChangedProfile
    case withdrawalStep
    case userIsLoggedOut
    
    
    case userReviewReels(Id: Int, mode: ReviewReelsMode)
    
    enum ReviewReelsMode {
        case home
        case store
        case myReview
        case bookmarkedReview
    }
}
