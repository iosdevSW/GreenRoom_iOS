//
//  RxNaverThirdPartyLoginProxy.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/16.
//


import NaverThirdPartyLogin
import SwiftKeychainWrapper
import RxSwift
import RxCocoa
import UIKit

class RxNaverThirdPartyLoginProxy : DelegateProxy<NaverThirdPartyLoginConnection, NaverThirdPartyLoginConnectionDelegate>,
                                    DelegateProxyType,NaverThirdPartyLoginConnectionDelegate {
    
    let oauthTokenSubject = PublishSubject<OAuthTokenModel>()
    
    //로그인 성공시 호출 ( 토큰 정상 발급 )
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        let oauthToken = OAuthTokenModel(oauthType: 1,
                                         accessToken: naverLoginInstance?.accessToken,
                                         refreshToken: naverLoginInstance?.refreshToken)
        oauthTokenSubject.onNext(oauthToken)
    }

    // 토큰갱신시 호출
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    // 로그아웃시 호출
    func oauth20ConnectionDidFinishDeleteToken() {
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "refreshToken")
    }
    // 에러 발생시
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        
    }
    
    public init(naverlogin: NaverThirdPartyLoginConnection) {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        super.init(parentObject: instance! , delegateProxy: RxNaverThirdPartyLoginProxy.self)
    }
    
    open class func currentDelegate(for object: NaverThirdPartyLoginConnection) -> NaverThirdPartyLoginConnectionDelegate? {
        return object.delegate
    }
    
    open class func setCurrentDelegate(_ delegate: NaverThirdPartyLoginConnectionDelegate?, to object: NaverThirdPartyLoginConnection) {
        object.delegate = delegate
    }
    
    static func registerKnownImplementations() {
        self.register { RxNaverThirdPartyLoginProxy(naverlogin: $0) }
    }
    
}

extension Reactive where Base: NaverThirdPartyLoginConnection {
    fileprivate var delegate: RxNaverThirdPartyLoginProxy {
        return RxNaverThirdPartyLoginProxy.proxy(for: base)
    }
    
    var subject: Observable<OAuthTokenModel> {
        return delegate.oauthTokenSubject.asObserver()
    }
}
