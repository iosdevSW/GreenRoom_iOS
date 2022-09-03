//
//  RxAppleLoginProxy.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/19.
//

import UIKit
import AuthenticationServices
import RxSwift
import RxCocoa

class RxAppleLoginProxy: DelegateProxy<ASAuthorizationController,ASAuthorizationControllerDelegate>,DelegateProxyType,ASAuthorizationControllerDelegate{
    static func registerKnownImplementations() {
        self.register { instance in RxAppleLoginProxy(parentObject: instance, delegateProxy: RxAppleLoginProxy.self) }
    }
    
    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
        object.delegate = delegate
    }
}

class RxAppleLoginContextProxy: DelegateProxy<ASAuthorizationController,ASAuthorizationControllerPresentationContextProviding>,DelegateProxyType,ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
        return sceneDelegate!.window!
    }
    
    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerPresentationContextProviding? {
        return object.presentationContextProvider
    }
    
    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerPresentationContextProviding?, to object: ASAuthorizationController) {
        object.presentationContextProvider = delegate
    }
    
    static func registerKnownImplementations() {
        self.register { instance in RxAppleLoginContextProxy(parentObject: instance, delegateProxy: RxAppleLoginContextProxy.self) }
    }
}

extension Reactive where Base: ASAuthorizationController {
    fileprivate var delegate: RxAppleLoginProxy {
        return RxAppleLoginProxy.proxy(for: base)
    }
    
    fileprivate var context: RxAppleLoginContextProxy {
        return RxAppleLoginContextProxy.proxy(for: base)
    }
    
    var didCompleteWithAuthorization: Observable<(ASAuthorizationController,ASAuthorization)> {
        return delegate.methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithAuthorization:)))
            .map{ param in
                let controller = param[0] as! ASAuthorizationController
                let auth = param[1] as! ASAuthorization
                
                return (controller,auth)
            }
    }
}
