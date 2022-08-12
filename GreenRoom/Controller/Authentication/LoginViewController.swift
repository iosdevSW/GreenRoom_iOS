//
//  LoginViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxKakaoSDKUser
import RxKakaoSDKAuth
import KakaoSDKUser
import KakaoSDKAuth
import NaverThirdPartyLogin
import AuthenticationServices


class LoginViewController: UIViewController{
    
    
    //MARK: - Properties
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let loginViewModel: LoginViewModel
    
    let disposeBag = DisposeBag()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientColor() // 배경색 그라데이션 설정
        self.naverLoginInstance?.delegate = self // 네이버로그인 델리게이트지정
        self.setTopView()
        self.setBottomView()
    }
    
    //MARK: - Init
    init(loginViewModel: LoginViewModel){
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickedLoginButton(_ btn: UIButton){
        if btn.tag == 0 { // 카카오톡 로그인 버튼 클릭시
            kakaoLogin()
        }else if btn.tag == 1 { // 네이버 로그인 버튼 클릭시
            naverLogin()
        }else { // Apple 로그인 버튼 클릭시
            appleLogin()
        }
    }
    
    func kakaoLogin() {
        loginViewModel.kakaoLogin()
            .subscribe(onNext: { response in
                if response.success {
                    guard let res = response.response else { return }
                    self.loginViewModel.tokenModel.accessToken = res.accessToken
                    self.loginViewModel.tokenModel.refreshToken = res.refreshToken
                    self.moveToGreenRoomVC()
                }else {
                    switch response.error?.status {
                    case 400:
                        //회원 정보 없음
                        self.moveToRegistVC() // 회원가입 화면으로
                    case 401:
                        // 토큰 유효하지 않음 -> 토큰 갱신
                        print(response.error!.message)
                    default:
                        print("serviceError: \(response.error!.message)")
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func naverLogin() {
        naverLoginInstance?.requestThirdPartyLogin()
    }
    
    func appleLogin() {
        
    }
    
    func moveToRegistVC() {
        let navigationVC = UINavigationController(rootViewController: RegistNameViewController(loginViewModel: self.loginViewModel))
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true, completion: {})
    }
    
    func moveToGreenRoomVC(){
        let mainTabbarController = UITabBarController()
        
        let greenRoomController = UINavigationController(rootViewController: GreenRoomViewController())
        let keywordController = UINavigationController(rootViewController: KeywordViewController())
        let mypageController = UINavigationController(rootViewController: MyPageViewController())
        
        greenRoomController.title = "그린룸"
        keywordController.title = "키워드연습"
        mypageController.title = "마이페이지"
        
        mainTabbarController.viewControllers = [greenRoomController,keywordController,mypageController]
        
        self.present(mainTabbarController, animated: true)
    }
}




//MARK: -UIConfigure
extension LoginViewController {
    func setTopView(){
        let imageView = UIImageView().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(named: "icon")
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.width.equalTo(170)
                make.height.equalTo(115)
                make.centerX.equalToSuperview()
                make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            }
        }
        
        _ = UILabel().then{ // imageUnderLabel
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .sfPro()
            $0.textColor = .white
            $0.text = "당신을 위한 작은 면접"
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(imageView.snp.bottom).offset(14)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    func setBottomView() {
        let frameView = UIView().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
            $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner) // 위 양옆 모서리만 둥글게
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(370)
            }
        }
        
        let separatorView = UIView().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            let height = 22.0
            $0.separatorLine(viewHeight: height)
            
            frameView.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.trailing.equalToSuperview()
                make.top.equalToSuperview().offset(44)
                make.height.equalTo(height)
            }
            
        }
        
        let loginLabel = PaddingLabel(padding: .init(top: 0, left: 8, bottom: 0, right: 8)).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            $0.text = "간편로그인"
            $0.textColor = .customDarkGray
            $0.font = .sfPro()
            
            separatorView.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.centerX.centerY.equalToSuperview()
            }
        }
        
        let kakaoLoginButton: UIButton = {
            let button = configureButton(button: UIButton(),
                                         title: "카카오톡으로 로그인",
                                         icon: "kakao",
                                         tag: 0,
                                         titleColor: .black,
                                         backgroundColor: UIColor(red: 254/255, green: 229/255, blue: 0, alpha: 1))
            button.addTarget(self, action: #selector(clickedLoginButton(_:)), for: .touchUpInside)
            frameView.addSubview(button)
            button.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(loginLabel.snp.bottom).offset(36)
                make.height.equalTo(48)
            }
            
            return button
        }()
        
        let naverLoginButton: UIButton = {
            let button = configureButton(button: UIButton(),
                                         title: "네이버로 로그인",
                                         icon: "naver",
                                         tag: 1,
                                         titleColor: .white,
                                         backgroundColor: UIColor(red: 0.118, green: 0.784, blue: 0, alpha: 1))
            button.addTarget(self, action: #selector(clickedLoginButton(_:)), for: .touchUpInside)
            frameView.addSubview(button)
            button.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(kakaoLoginButton.snp.bottom).offset(14)
                make.height.equalTo(48)
            }
            
            return button
        }()
        
        let appleLoginButton: ASAuthorizationAppleIDButton = {
            let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
            button.cornerRadius = 15
//            let button = configureButton(button: UIButton(),
//                                         title: "Apple로 로그인",
//                                         icon: "apple",
//                                         tag: 2,
//                                         titleColor: .white,
//                                         backgroundColor: .black)
//            button.addTarget(self, action: #selector(clickedLoginButton(_:)), for: .touchUpInside)
            frameView.addSubview(button)
            button.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(naverLoginButton.snp.bottom).offset(14)
                make.height.equalTo(48)
            }
            
            return button
        }()
    }
    
    func configureButton(button: UIButton, title: String, icon: String, tag: Int, titleColor: UIColor, backgroundColor: UIColor )->UIButton{
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: icon), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .center
        button.semanticContentAttribute = .forceLeftToRight
        button.setTitleColor(titleColor, for: .normal)
        button.tag = tag
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            var titleAttr = AttributedString.init(title)
            titleAttr.font = .sfPro(size: 17, family: .Bold)
            titleAttr.foregroundColor = titleColor
            config.attributedTitle = titleAttr
            config.imagePadding = 20
            config.baseBackgroundColor = backgroundColor
            config.background.cornerRadius = 15
            button.configuration = config
        }else {
            button.layer.cornerRadius = 15
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = .sfPro(size: 17, family: .Bold)
            button.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
            button.backgroundColor = backgroundColor
        }
        
        return button
    }
}
// 네이버 access 토큰 유효 기간 3,600초 (1시간)
// isValidAcccessTokenExpireTimeNow -> 토큰이 유효한지 확인하는메소드
extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("로그인 성공시 호출") // 성공적으로 토큰이 생겼을시 호출되는 것 같음 이미 토큰이 있을때 로그인버튼을 누르면 실행 안됨
        LoginService.naverLoginPaser()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 토큰\(naverLoginInstance?.accessToken)")
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃시 호출")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("에러 = \(error.localizedDescription)")
    }
    
   
}
