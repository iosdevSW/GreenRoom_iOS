//
//  RegistNameViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/04.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa



class RegistNameViewController: UIViewController {
    //MARK: - Properties
    let loginViewModel: LoginViewModel
    
    var disposeBag = DisposeBag()
    
    var nameTextfield: UITextField!
    var textfieldBox: UIView!
    var nextButton: UIButton!
    var guideLabel: UILabel!
    
    var oauthType: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        self.setNavigationItem()
        self.hideKeyboardWhenTapped()
        
        nameTextfield.rx.text
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { text in
                if text == "" {
                    self.nextButton.setEnableButton(false)
                }else {
                    LoginService.checkName(name: text!)
                        .subscribe(onNext:{ bool in
                            self.duplicatedName(bool: bool)
                        }).disposed(by: self.disposeBag)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Init
    init(loginViewModel: LoginViewModel, oauthType: Int){
        self.loginViewModel = loginViewModel
        self.oauthType = oauthType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickedNextButton(_: UIButton){
        self.navigationController?.pushViewController(RegistCategoryViewController(name: nameTextfield.text!, oauthType: oauthType), animated: true)
    }
    
    @objc func generateRandomName(_: UIButton){
        LoginService.generateRandomName()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { name in
                self.nameTextfield.rx.text.onNext(name)
                LoginService.checkName(name: name)
                    .subscribe(onNext:{ bool in
                        self.duplicatedName(bool: bool)
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    func duplicatedName(bool: Bool){
        if bool {
            self.textfieldBox.layer.borderColor = UIColor.darken.cgColor

        }else {
            self.textfieldBox.layer.borderColor = UIColor.red.cgColor
        }
        self.guideLabel.isHidden = bool
        self.nextButton.setEnableButton(bool)
    }
}


//MARK: - Configure UI
extension RegistNameViewController {
    func configureUI(){
        let nameLabel = UILabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .sfPro(size: 30, family: .Semibold)
            $0.text = "이름이 무엇인가요?"
            $0.textColor = .black
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(143)
                make.centerX.equalToSuperview()
            }
        }
        
        textfieldBox = UIView().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.darken.cgColor
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(nameLabel.snp.bottom).offset(100)
                make.height.equalTo(64)
            }
        }
        
        guideLabel = UILabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "! 이미 등록된 이름이에요"
            $0.textColor = .red
            $0.font = .sfPro(size: 12, family: .Semibold)
            $0.isHidden = true
            self.view.addSubview($0)
            
            $0.snp.makeConstraints{ make in
                make.bottom.equalTo(textfieldBox.snp.top).offset(5)
                make.leading.equalTo(textfieldBox.snp.leading).offset(12)
            }
        }
        
            self.nameTextfield = UITextField().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .customDarkGray
            $0.font = .sfPro(size: 20, family: .Regular)
            $0.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요 :)",
                                                          attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray!])
            
            textfieldBox.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(28)
                make.trailing.equalToSuperview().offset(-28)
                make.top.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-15)
            }
        }
        
        let autoInputButton = UIButton(type: .system).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(.darken, for: .normal)
            $0.titleLabel?.font = .sfPro()
            $0.setTitle("이름 자동입력", for: .normal)
            $0.addTarget(self, action: #selector(self.generateRandomName(_:)), for: .touchUpInside)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.top.equalTo(textfieldBox.snp.bottom).offset(36)
            }
        }
        
        self.nextButton = UIButton(type: .system).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .sfPro(size: 22, family: .Semibold)
            $0.layer.cornerRadius = 15
            $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.backgroundColor = .mainColor
            $0.isEnabled = false
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.bottom.equalToSuperview().offset(-96)
                make.leading.equalToSuperview().offset(36)
                make.trailing.equalToSuperview().offset(-36)
                make.height.equalTo(54)
            }
            $0.addTarget(self, action: #selector(clickedNextButton(_:)), for: .touchUpInside)
        }
    }
    
    override func setNavigationItem() {
        super.setNavigationItem()
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .mainColor
    }
}
