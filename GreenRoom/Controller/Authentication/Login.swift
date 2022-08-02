//
//  Login.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - Properties
    var loginViewModel = LoginViewModel()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientColor() // 배경색 그라데이션 설정
        self.setBottomView()
        self.setTopView()
    }
    
    func setTopView(){
        let imageView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.image = UIImage(named: "icon")
            self.view.addSubview(view)
            
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 170),
                view.heightAnchor.constraint(equalToConstant: 115),
                view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 200)
            ])
            
            return view
        }()
        
        let imageUnderLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .sfPro()
            label.textColor = .white
            label.text = "당신을 위한 작은 면접"
            self.view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14),
                label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ])
            
            return label
        }()
    }
    
    func setBottomView() {
        let frameView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = 15
            view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
            self.view.addSubview(view)
            
            return view
        }()
        
        let separatorView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.separatorLabel(viewHeight: 22)
            view.backgroundColor = .white
            frameView.addSubview(view)
            
            return view
        }()
        
        let loginLabel: PaddingLabel = {
            let label = PaddingLabel(padding: .init(top: 0, left: 8, bottom: 0, right: 8))
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .white
            label.text = "간편로그인"
            label.textColor = .customDarkGray
            label.font = .sfPro()
            separatorView.addSubview(label)
            
            return label
        }()
        
        let kakaoLoginButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "kakao"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .center
            button.semanticContentAttribute = .forceLeftToRight
            button.setTitleColor(.black, for: .normal)
            button.tag = 0
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.filled()
                var titleAttr = AttributedString.init("카카오톡으로 로그인")
                titleAttr.font = .sfPro(size: 17, family: .Bold)
                titleAttr.foregroundColor = .black
                config.attributedTitle = titleAttr
                config.imagePadding = 20
                config.baseBackgroundColor = UIColor(red: 254/255, green: 229/255, blue: 0, alpha: 1)
                config.background.cornerRadius = 15
                button.configuration = config
            }else {
                button.titleLabel?.font = .sfPro(size: 17, family: .Bold)
                button.layer.cornerRadius = 15
                button.setTitle("카카오톡으로 로그인", for: .normal)
                button.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
                button.backgroundColor = UIColor(red: 254/255, green: 229/255, blue: 0, alpha: 1)
            }
            frameView.addSubview(button)
            
            return button
        }()
        
        let naverLoginButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "naver"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .center
            button.semanticContentAttribute = .forceLeftToRight
            button.setTitleColor(.white, for: .normal)
            button.tag = 1
            
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.filled()
                var titleAttr = AttributedString.init("네이버로 로그인")
                titleAttr.font = .sfPro(size: 17, family: .Bold)
                config.attributedTitle = titleAttr
                config.imagePadding = 20
                config.baseBackgroundColor = UIColor(red: 0.118, green: 0.784, blue: 0, alpha: 1)
                config.background.cornerRadius = 15
                button.configuration = config
            }else {
                button.layer.cornerRadius = 15
                button.setTitle("네이버로 로그인", for: .normal)
                button.titleLabel?.font = .sfPro(size: 17, family: .Bold)
                button.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
                button.backgroundColor = UIColor(red: 0.118, green: 0.784, blue: 0, alpha: 1)
            }
            frameView.addSubview(button)
            
            return button
        }()
        
        let appleLoginButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(named: "apple"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.contentHorizontalAlignment = .center
            button.semanticContentAttribute = .forceLeftToRight
            button.setTitleColor(.white, for: .normal)
            button.tag = 2
            
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.filled()
                var titleAttr = AttributedString.init("Apple로 로그인")
                titleAttr.font = .sfPro(size: 17, family: .Bold)
                config.attributedTitle = titleAttr
                config.imagePadding = 20
                config.baseBackgroundColor = .black
                config.background.cornerRadius = 15
                button.configuration = config
            }else {
                button.layer.cornerRadius = 15
                button.setTitle("Apple로 로그인", for: .normal)
                button.titleLabel?.font = .sfPro(size: 17, family: .Bold)
                button.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 15)
                button.backgroundColor = .black
            }
            frameView.addSubview(button)
            
            return button
        }()

        
        //layout
        NSLayoutConstraint.activate([
            frameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            frameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            frameView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            frameView.heightAnchor.constraint(equalToConstant: 370)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: frameView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: frameView.trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: frameView.topAnchor, constant: 44),
            separatorView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: separatorView.centerXAnchor),
            loginLabel.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            kakaoLoginButton.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 24),
            kakaoLoginButton.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -24),
            kakaoLoginButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 36),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            naverLoginButton.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 24),
            naverLoginButton.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -24),
            naverLoginButton.topAnchor.constraint(equalTo: kakaoLoginButton.bottomAnchor, constant: 14),
            naverLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            appleLoginButton.leadingAnchor.constraint(equalTo: frameView.leadingAnchor, constant: 24),
            appleLoginButton.trailingAnchor.constraint(equalTo: frameView.trailingAnchor, constant: -24),
            appleLoginButton.topAnchor.constraint(equalTo: naverLoginButton.bottomAnchor, constant: 14),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
