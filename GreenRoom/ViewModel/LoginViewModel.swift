//
//  LoginViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import RxSwift
import RxCocoa
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import SwiftKeychainWrapper
import NaverThirdPartyLogin

class LoginViewModel {
    let disposeBag = DisposeBag()
    let loginService = LoginService()
    
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    var oauthToken = PublishSubject<OAuthTokenModel>()
    var loginObservable = PublishSubject<LoginModel>()
    
    init(){
        oauthToken.asObserver() // oauth 토큰 발급 옵저버
            .take(1)
            .subscribe(onNext: { [self]token in
                _ = self.loginService.loginAPI(token.accessToken!)
                    .take(1)
                    .bind(to: loginObservable)
            }).disposed(by: disposeBag)
        
        naverLoginInstance?.rx.subject
            .take(1)
            .subscribe(onNext: { oauthToken in
                self.oauthToken.onNext(oauthToken)
            }).disposed(by: disposeBag)
            
    }
    
    func oauthLogin(oauthType: Int){
        switch oauthType {
            case 0: kakaoLogin(oauthType: oauthType)            // 0: 카카오톡 로그인
            case 1: naverLogin(oauthType: oauthType)            // 1: 네이버 로그인
            default: appleLogin(oauthType: oauthType)           // 2: 애플 로그인
        }
    }
    
    func kakaoLogin(oauthType: Int){
        if (UserApi.isKakaoTalkLoginAvailable()) { // 카카오톡 설치 여부 확인
            UserApi.shared.rx.loginWithKakaoTalk() // 카카오톡 앱 로그인
                .subscribe(onNext:{ (oauthToken) in
                    let oauthToken = OAuthTokenModel(oauthType: oauthType,
                                                     accessToken: oauthToken.accessToken,
                                                     refreshToken: oauthToken.refreshToken)
                    self.oauthToken.onNext(oauthToken)
                },onError: { error in
                    print("kakaoAppLoginError: \(error)")
                }).disposed(by: self.disposeBag)

               
        }else { // 카카오톡 앱x 웹 로그인
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { oauthToken in
                    self.oauthToken.onNext(OAuthTokenModel(oauthType: oauthType,
                                                           accessToken: oauthToken.accessToken,
                                                           refreshToken: oauthToken.refreshToken))
                }, onError: {error in
                    print("kakaoWebLoginError: \(error)")
                }).disposed(by: self.disposeBag)
        }
    }
    
    func naverLogin(oauthType: Int) {
        naverLoginInstance?.requestThirdPartyLogin()
    }
    
    func appleLogin(oauthType: Int) {
        naverLoginInstance?.requestDeleteToken()
        UserApi.shared.logout{_ in ()}
    }
}
