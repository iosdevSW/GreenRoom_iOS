//
//  LoginViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import RxSwift
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser

// 여기서 access 토큰을 서버로 던지고, 사용자 정보를 조회하는 ViewModel함수 호출하기.
// 로직은 Viewmodel에서 구현하고 호출만 하기. ( 파라미터로 토큰 넘기고 JSON을 받아 처리해야함)
// 이 JSON엔 JWT (JSon Web Token (서버에서 만든 AccessToken과 Refresh Token)이 있고 이걸로 서버와 통신해야함.
// 실패시 Refresh Token을 통해 갱신해주어야함.  갱신되면 저장을 해야한다는 말이 만료기간도 갱신시점부터 다시 늘어난다는 건가?
// refresh 토큰도 만료되었다면 로그인창에서 다시 로그인


class LoginViewModel {
    var tokenModel = Token(accessToken: nil, refreshToken: nil)
    let disposeBag = DisposeBag()
    
    func kakaoLogin()->Observable<LoginModel>{
        // 카카오톡 설치 여부 확인
        
            if (UserApi.isKakaoTalkLoginAvailable()) {
                return Observable<LoginModel>.create{ emitter in
                    UserApi.shared.rx.loginWithKakaoTalk()
                        .subscribe(onNext:{ (oauthToken) in
                            LoginService.loginAPI(oauthToken.accessToken)
                                .subscribe(onNext:{ response in
                                    emitter.onNext(response)
                                }).disposed(by: self.disposeBag)
                        },onError: { error in
                            print("kakaoAppLoginError: \(error)")
                        }).disposed(by: self.disposeBag)
                    
                    return Disposables.create()
                }
            }else { // 카카오톡 앱x 웹 로그인
                return Observable<LoginModel>.create{ emitter in
                    UserApi.shared.rx.loginWithKakaoAccount()
                        .subscribe(onNext: { oauthToken in
                            LoginService.loginAPI(oauthToken.accessToken)
                                .subscribe(onNext:{ response in
                                    emitter.onNext(response)
                                }).disposed(by: self.disposeBag)
                        }, onError: {error in
                            print("kakaoWebLoginError: \(error)")
                        }).disposed(by: self.disposeBag)
                        
                    return Disposables.create()
                }
            }
    }
        
    func registUser(){
        
    }
}
