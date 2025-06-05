//
//  appleSignIn.swift
//  TaskManagementApp
//
//  Created by Paranjothi iOS MacBook Pro on 05/06/25.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseCore
import Firebase

@available(iOS 13.0, *)
class AppleSignInManager: NSObject {

//    static let shared = AppleSignInManager()
    var harisCount: Int = 2
    let harisNewFriend: String? = "jeeva"
    var window: UIWindow? = nil

    func startSignInWithAppleFlow() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension AppleSignInManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window ?? UIWindow()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

    }


    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple Sign-In Failed: \(error.localizedDescription)")
    }
}
 
