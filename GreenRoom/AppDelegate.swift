//
//  AppDelegate.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import KakaoSDKCommon
import RxKakaoSDKCommon
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: Storage().kakaoAppKey) //Kakao SDK Init
        
        if #available(iOS 15.0, *) {
            let tabbarAppearance = UITabBarAppearance()
            tabbarAppearance.configureWithOpaqueBackground()
            
            tabbarAppearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = tabbarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabbarAppearance
            
            //tabbar upper line remove
            UITabBar.appearance().clipsToBounds = true
        }
        //Naver
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
                
            // 네이버 앱으로 인증하는 방식 활성화
            instance?.isNaverAppOauthEnable = true
            
            // SafariViewController에서 인증하는 방식 활성화
            instance?.isInAppOauthEnable = true
            
            // 인증 화면을 아이폰의 세로모드에서만 적용
            instance?.isOnlyPortraitSupportedInIphone()
            
            instance?.serviceUrlScheme = kServiceAppUrlScheme // 앱을 등록할 때 입력한 URL Scheme
            instance?.consumerKey = kConsumerKey // 상수 - client id
            instance?.consumerSecret = kConsumerSecret // pw
            instance?.appName = kServiceAppName // app name
            
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//     모든 뷰에서 세로 화면 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }


}

