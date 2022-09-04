//
//  LoginViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//


import AuthenticationServices
import UIKit

import Alamofire
import KakaoSDKUser
import NaverThirdPartyLogin
import Then
import RxCocoa
import RxSwift
import RxKakaoSDKUser
import RxKakaoSDKAuth
import SnapKit
import SwiftKeychainWrapper


class LoginViewController: UIViewController{
    //MARK: - Properties
    let loginViewModel: LoginViewModel
    var oauthTokenInfo  = OAuthTokenModel()
    let disposeBag = DisposeBag()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientColor() // 배경색 그라데이션 설정
        self.setTopView()
        self.setBottomView()
        self.subscribe()
    }
    
    //MARK: - Init
    init(loginViewModel: LoginViewModel){
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didClickedLoginButton(_ btn: UIButton){
        loginViewModel.oauthLogin(oauthType: btn.tag)
    }
    
    func subscribe(){
        // oauthtoken 발급시 oauth토큰 정보 가져오기
        _ = loginViewModel.oauthToken
            .take(1)
            .subscribe(onNext: { tokenModel in
                self.oauthTokenInfo = tokenModel
            })
        
        // JWT토큰 받아 키체인에 저장하고 예외처리
        loginViewModel.loginObservable
            .take(1)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { res in
                print(res.accessToken)
                KeychainWrapper.standard.set(res.accessToken, forKey: "accessToken")
                KeychainWrapper.standard.set(res.refreshToken, forKey: "refreshToken")
                self.dismiss(animated: true)
            },onError: { error in
                guard let statusCode = error.asAFError?.responseCode else { return }
                switch statusCode {
                case 400:
                    //회원 정보 없음
                    self.moveToRegistVC() // 회원가입 화면으로
                case 401:
                    // 토큰 유효하지 않음 -> 토큰 갱신
                    print("유효하지 않은 토큰")
                default:
                    print("serviceError: \(error.localizedDescription)")
                }
            }).disposed(by: disposeBag)
    }
    
    func moveToRegistVC() {
        let navigationVC = UINavigationController(rootViewController: RegisterNameViewController(loginViewModel: loginViewModel, oauthTokenInfo: oauthTokenInfo))
        navigationVC.modalPresentationStyle = .fullScreen
        self.present(navigationVC, animated: true, completion: {})
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
            button.addTarget(self, action: #selector(didClickedLoginButton(_:)), for: .touchUpInside)
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
            button.addTarget(self, action: #selector(didClickedLoginButton(_:)), for: .touchUpInside)
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
            button.tag = 2
         
            button.addTarget(self, action: #selector(didClickedLoginButton(_:)), for: .touchUpInside)
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
