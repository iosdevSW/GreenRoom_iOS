//
//  SceneDelegate.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import NaverThirdPartyLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = createCustomTabbar()
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //kakao
        guard let url =  URLContexts.first?.url else { return }
        
        let str = url.absoluteString
        
        if str.hasPrefix("kakao"){ // kakao
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }else{ // naver
            NaverThirdPartyLoginConnection
              .getSharedInstance()?
              .receiveAccessToken(url)
        }
    }
}

extension SceneDelegate {
    
    private func createCustomTabbar() -> CustomTabbarController {
        let mainTabbarController = CustomTabbarController()
        
        let greenRoomController = self.createNavigationController(viewController: GreenRoomViewController(viewModel: MainGreenRoomViewModel()),
                                                                  title: "그린룸",
                                                                  image: UIImage(named: "greenroom"),
                                                                  tag: 1)
        
        let keywordController = self.createNavigationController(viewController:
                                                                    KPMainViewController(viewModel: KeywordViewModel()),
                                                                title: "키워드연습",
                                                                image: UIImage(named: "keyword"),
                                                                tag: 2)
      
        let mypageController = self.createNavigationController(viewController:
                                                                MyPageViewController(viewModel: MyPageViewModel()),
                                                               title: "마이페이지",
                                                               image: UIImage(named: "mypage"),
                                                               tag: 3)
        mainTabbarController.tabBar.tintColor = .darken
        mainTabbarController.tabBar.unselectedItemTintColor = .customGray
        mainTabbarController.viewControllers = [keywordController,greenRoomController,mypageController]
        mainTabbarController.selectedIndex = 1

        return mainTabbarController
    }
    
    private func createNavigationController(viewController: UIViewController, title: String, image: UIImage?, tag: Int) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.title = title
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.tag = 2
        
        return navigationController
    }
}
