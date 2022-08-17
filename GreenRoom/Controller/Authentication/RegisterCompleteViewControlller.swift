//
//  RegisterCompleteViewControlller.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/07.
//

import UIKit
import SnapKit
import SwiftKeychainWrapper
import RxSwift

class RegisterCompleteViewControlller: UIViewController{
    var completeButton: UIButton!
    let loginViewModel = LoginViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        configureUI()
    }
    
    @objc func didClickCompleteButton(_: UIButton){
        guard let oauthAccessToken = KeychainWrapper.standard.string(forKey: "oauthAccessToken") else { return }
        loginViewModel.loginService.loginAPI(oauthAccessToken)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { res in
                KeychainWrapper.standard.set(res.accessToken, forKey: "accessToken")
                KeychainWrapper.standard.set(res.refreshToken, forKey: "refreshToken")
                
                self.dismiss(animated: true)
            },onError: { error in
                guard let statusCode = error.asAFError?.responseCode else { return }
                switch statusCode {
                case 400:
                    //회원 정보 없음
                    print("회원가입 안된경우")
                case 401:
                    // 토큰 유효하지 않음 -> 토큰 갱신
                    print("유효하지 않은 토큰")
                default:
                    print("serviceError: \(error.localizedDescription)")
                }
            }).disposed(by: disposeBag)
    }
}

extension RegisterCompleteViewControlller {
    func configureUI(){
        let completeLable = UILabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .sfPro(size: 30, family: .Semibold)
            $0.textColor = .black
            $0.text = "가입 완료!"
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(112)
                make.centerX.equalToSuperview()
            }
        }
        
        let greenLabel = UILabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .sfPro(size: 16, family: .Regular)
            $0.textColor = .customGray
            $0.text = "그린룸과 함께하는 면접연습 :)"
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(completeLable.snp.bottom).offset(6)
                make.centerX.equalToSuperview()
            }
        }
        
        let firstCheckLabel = CheckLabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.mainLabel.text = "면접 질문을 작성하고 공유할 수 있어요!"
            $0.descriptionLabel.text = "나만의 질문리스트를 작성하고 수정/보관할 수 있어요."
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(greenLabel.snp.bottom).offset(60)
                make.leading.equalToSuperview().offset(40)
            }
        }
        
        let secondCheckLabel = CheckLabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.mainLabel.text = "나와 같은 동료들의 답변을 확인할 수 있어요!"
            $0.descriptionLabel.text = "그린룸을 통해 궁금한 질문을 올리고 답변을 공유할 수 있어요."
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(firstCheckLabel.snp.bottom).offset(27)
                make.leading.equalToSuperview().offset(40)
            }
        }
        
        let thirdCheckLabel = CheckLabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.mainLabel.text = "다양한 면접 연습을 제공받을 수 있어요!"
            $0.descriptionLabel.text = "그린룸에서 제공하는 질문 프리셋과 그린룸 질문을 통해\n다양한 면접 연습이 가능해요."
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(secondCheckLabel.snp.bottom).offset(27)
                make.leading.equalToSuperview().offset(40)
            }
        }
        
        self.completeButton = UIButton(type: .system).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .sfPro(size: 22, family: .Semibold)
            $0.layer.cornerRadius = 15
            $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.backgroundColor = .mainColor
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.bottom.equalToSuperview().offset(-96)
                make.leading.equalToSuperview().offset(36)
                make.trailing.equalToSuperview().offset(-36)
                make.height.equalTo(54)
            }
            $0.addTarget(self, action: #selector(didClickCompleteButton(_:)), for: .touchUpInside)
        }
    }
}
