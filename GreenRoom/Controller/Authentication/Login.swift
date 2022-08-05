//
//  Login.swift
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
import Alamofire


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
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ (oauthToken) in // 로그인 정상적으로 완료 -> 토큰
                    let accessToken = oauthToken.accessToken
                    // 여기서 access 토큰을 서버로 던지고, 사용자 정보를 조회하는 ViewModel함수 호출하기.
                    // 로직은 Viewmodel에서 구현하고 호출만 하기. ( 파라미터로 토큰 넘기고 JSON을 받아 처리해야함)
                    // 이 JSON엔 JWT (JSon Web Token (서버에서 만든 AccessToken과 Refresh Token)이 있고 이걸로 서버와 통신해야함.
                    // 실패시 Refresh Token을 통해 갱신해주어야함.  갱신되면 저장을 해야한다는 말이 만료기간도 갱신시점부터 다시 늘어난다는 건가?
                    // refresh 토큰도 만료되었다면 로그인창에서 다시 로그인
                    print("accessToken: \(accessToken)")
                    let navigationVC = UINavigationController(rootViewController: RegistNameViewController(loginViewModel: LoginViewModel(loginService: LoginService())))
                    navigationVC.modalPresentationStyle = .fullScreen
                    self.present(navigationVC, animated: true, completion: {})
//
                }, onError: {error in // 에러시
                    print(error)
                })
            .disposed(by: disposeBag)
        }
    }
    
    func naverLogin() {
        naverLoginInstance?.requestThirdPartyLogin()
    }
    
    func appleLogin() {

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
        
        let appleLoginButton: UIButton = {
            let button = configureButton(button: UIButton(),
                                         title: "Apple로 로그인",
                                         icon: "apple",
                                         tag: 2,
                                         titleColor: .white,
                                         backgroundColor: .black)
            button.addTarget(self, action: #selector(clickedLoginButton(_:)), for: .touchUpInside)
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
        loginViewModel.naverLoginPaser()
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
