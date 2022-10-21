//
//  EditProfileInfoViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/17.
//
import UIKit
import RxSwift
import RxCocoa

protocol EditProfileInfoDelegate {
    func editNickName(textField: Observable<String>)
}

final class EditProfileInfoViewController: BaseViewController {
    
    //MARK: - properties
    private let viewModel: EditProfileViewModel
    
    private let nameLabel = UILabel().then{
        $0.text = "이름"
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
    }
    
    private lazy var nameTextField = UITextField().then {
        $0.text = "박면접"
        $0.textAlignment = .right
        $0.textColor = .black
        $0.font = .sfPro(size: 16, family: .Bold)
        $0.backgroundColor = .white
    }
    
    private lazy var logoutButton = UIButton().then {
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "로그아웃"
        configuration.image = UIImage(systemName: "chevron.right")
        configuration.imagePadding = 230
        configuration.imagePlacement = .trailing
        configuration.baseForegroundColor = .black
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 63)
        $0.titleLabel?.font = .sfPro(size: 16, family: .Regular)
        $0.imageView?.tintColor = .black
        $0.backgroundColor = .white
        
        $0.configuration = configuration
    }
    
    private lazy var withdrawalButton = UIButton().then {
        
        var configuration = UIButton.Configuration.plain()
        configuration.title = "회원 탈퇴"
        configuration.baseForegroundColor = .black
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 280)
        
        $0.titleLabel?.textColor = .black
        $0.titleLabel?.font = .sfPro(size: 16, family: .Regular)
        $0.configuration = configuration
    }
    
    //MARK: - lifecycle
    init(viewModel: EditProfileViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.inputViewController?.hidesBottomBarWhenPushed = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .mainColor
    }
    
    override func configureUI(){
        view.backgroundColor = .white
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(49)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        self.view.addSubview(nameTextField)
        self.nameTextField.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.trailing.equalToSuperview().offset(-58)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(26)
            
        }
        self.view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(62)
        }
        
        self.view.addSubview(withdrawalButton)
        withdrawalButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(logoutButton.snp.bottom).offset(10)
        }
    }
    
    override func setupBinding() {
        let input = EditProfileViewModel.Input(trigger: self.rx.viewWillAppear.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.userName.bind(to: self.nameTextField.rx.text).disposed(by: disposeBag)
        
        nameTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                guard let nickname = self?.nameTextField.text else { return }
                self?.viewModel.updateUserInfo(nickName: nickname)
            }).disposed(by: disposeBag)
        
        withdrawalButton.rx.tap
            .subscribe(onNext: {
                
            }).disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .subscribe(onNext: {
                
            }).disposed(by: disposeBag)
    }
}

