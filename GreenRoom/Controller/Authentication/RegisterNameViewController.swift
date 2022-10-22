//
//  RegisterNameViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/04.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa



class RegisterNameViewController: UIViewController {
    //MARK: - Properties
    let loginViewModel: LoginViewModel
    
    var disposeBag = DisposeBag()
    
    var oauthTokenInfo: OAuthTokenModel!
    
    let nameTextfield = UITextField().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .customDarkGray
        $0.font = .sfPro(size: 20, family: .Regular)
        $0.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요 :)",
                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray!])
    }
    
    let nameLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .sfPro(size: 30, family: .Semibold)
        $0.text = "이름이 무엇인가요?"
        $0.textColor = .black
    }
    
    let textfieldBox = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.darken.cgColor
    }
    
    let nextButton = UIButton(type: .system).then{
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
    }
    
    let guideLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "! 이미 등록된 이름이에요"
        $0.textColor = .red
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.isHidden = true
    }
    
    let autoInputNameButton = UIButton(type: .system).then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitleColor(.darken, for: .normal)
        $0.titleLabel?.font = .sfPro()
        $0.setTitle("이름 자동입력", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubView()
        layout()
        configureUI()
        
        self.setNavigationItem()
        self.hideKeyboardWhenTapped()
        
        nameTextfield.rx.text
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { text in
                if text == "" {
                    self.nextButton.setEnableButton(false)
                }else {
                    AuthService.shared.checkName(name: text!)
                        .subscribe(onNext:{ isDuplicated in
                            self.checkDuplicateName(isDuplicated: isDuplicated)
                        }).disposed(by: self.disposeBag)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Init
    init(loginViewModel: LoginViewModel, oauthTokenInfo: OAuthTokenModel){
        self.loginViewModel = loginViewModel
        self.oauthTokenInfo = oauthTokenInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didClickNextButton(_: UIButton){
        self.navigationController?.pushViewController(RegisterCategoryViewController(name: nameTextfield.text!, oauthTokenInfo: oauthTokenInfo), animated: true)
    }
    
    @objc func didClickRandomNameButton(_: UIButton){
        AuthService.shared.generateRandomName()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { name in
                self.nameTextfield.rx.text.onNext(name)
                AuthService.shared.checkName(name: name)
                    .subscribe(onNext:{ isDuplicated in
                        self.checkDuplicateName(isDuplicated: isDuplicated)
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    func checkDuplicateName(isDuplicated: Bool){
        self.textfieldBox.layer.borderColor = isDuplicated ? UIColor.darken.cgColor : UIColor.red.cgColor
        self.guideLabel.isHidden = isDuplicated
        self.nextButton.setEnableButton(isDuplicated)
    }
}


//MARK: - Configure UI
extension RegisterNameViewController {
    func addSubView(){
        self.view.addSubview(self.nameLabel)
        
        self.view.addSubview(self.textfieldBox)
        
        self.view.addSubview(self.guideLabel)
        
        self.view.addSubview(self.autoInputNameButton)
        
        self.view.addSubview(self.nextButton)
        
        self.textfieldBox.addSubview(self.nameTextfield)
    }
    
    func layout(){
        self.nameLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(143)
            make.centerX.equalToSuperview()
            
        }
        
        self.textfieldBox.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalTo(nameLabel.snp.bottom).offset(100)
            make.height.equalTo(64)
        }
        
        self.guideLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(textfieldBox.snp.top).offset(-5)
            make.leading.equalTo(textfieldBox.snp.leading).offset(12)
        }
        
        self.nameTextfield.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        self.autoInputNameButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textfieldBox.snp.bottom).offset(36)
        }
        
        self.nextButton.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().offset(-96)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(54)
        }
        
    }
    
    func configureUI(){
        self.autoInputNameButton.addTarget(self, action: #selector(self.didClickRandomNameButton(_:)), for: .touchUpInside)

        self.nextButton.addTarget(self, action: #selector(didClickNextButton(_:)), for: .touchUpInside)
    }
    
    override func setNavigationItem() {
        super.setNavigationItem()
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .mainColor
    }
}
