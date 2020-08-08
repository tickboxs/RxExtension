//
//  Apple+Rx.swift
//  RxExtension
//
//  Created by Charlie Cai on 8/8/20.
//  Copyright © 2020 tickboxs. All rights reserved.
//

import Foundation
import AuthenticationServices
import RxSwift
import RxCocoa

@available(iOS 13.0, *)
class Apple:NSObject {
    static let shared = Apple()
    fileprivate let subject = PublishSubject<ASAuthorizationAppleIDCredential>()
}

@available(iOS 13.0, *)
extension Reactive where Base:Apple {
    
    @available(iOS 13.0, *)
    func login() -> Observable<ASAuthorizationAppleIDCredential> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName,.email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = base
        authorizationController.presentationContextProvider = base
        authorizationController.performRequests()
        return base.subject.asObservable()
    }
}

@available(iOS 13.0, *)
extension Apple: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("credential could not convert to ASAuthorizationAppleIDCredential")
            assertionFailure("credential could not convert to ASAuthorizationAppleIDCredential")
            return
        }
        
        subject.onNext(credential)
        subject.onCompleted()
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        subject.onError(error)
    }
    
}

@available(iOS 13.0, *)
extension Apple:ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        guard let keyWindow = UIApplication.shared.delegate?.window else {
            print("if you see this,it means you cannot get current keywindow using UIApplication.shared.delegate?.window.if this ever happen to you ,please find another way to get current keyWindow")
            assertionFailure("could not get current keyWindow")
            return UIWindow()
        }

        return keyWindow ?? UIWindow()
    }
    
}


