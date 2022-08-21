//
//  KeywordViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import SwiftKeychainWrapper
import NaverThirdPartyLogin

class KeywordViewController: UIViewController{
    //MARK: - Properties
    
    let searchBarView = UISearchBar().then{
        $0.placeholder = "키워드로 검색해보세요!"
        $0.layer.borderWidth = 2
        $0.searchBarStyle = .minimal
        $0.searchTextField.borderStyle = .none
        $0.searchTextField.textColor = .customDarkGray
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.searchTextField.leftView?.tintColor = .customGray
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    let filterButton = UIButton(type: .roundedRect).then{
        $0.backgroundColor = .mainColor
        $0.setTitle("필터 ", for: .normal)
        $0.titleLabel?.font = .sfPro(size: 12, family: .Semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.setImage(UIImage(named: "filter"), for: .normal)
        $0.tintColor = .white
        $0.semanticContentAttribute = .forceRightToLeft
        $0.layer.cornerRadius = 15
    }
    
    let segmentControl = UISegmentedControl(items: ["기본질문","그린룸 질문"]).then{
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.selectedSegmentTintColor = UIColor.white
        $0.setBackgroundImage(UIImage(named: "filter"), for: .normal, barMetrics: .default)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customGray]
        $0.setTitleTextAttributes(titleTextAttributes, for:.normal)
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainColor]
        $0.setTitleTextAttributes(selectedTitleTextAttributes, for:.selected)
        
    }
    
    let btn = UIButton(type: .roundedRect).then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("logout", for: .normal)
        
    }
    //MARK: - ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        hideKeyboardWhenTapped()
        btn.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
    }
    
    
    //MARK: - Selector
    @objc func logout(_ sender: UIButton){
        LoginService.logout()
            .subscribe(onNext: { isToken in
                if isToken {
                    KeychainWrapper.standard.removeObject(forKey: "accessToken")
                    KeychainWrapper.standard.removeObject(forKey: "refreshToken")
                    
                    self.present(LoginViewController(loginViewModel: LoginViewModel()), animated: false)
                }else {
                    
                }
            })
        
    }
}

//MARK: - ConfigureUI
extension KeywordViewController {
    func configureUI(){
        self.view.addSubview(searchBarView)
        self.searchBarView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(74)
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalToSuperview().offset(-34)
            make.height.equalTo(36)
        }
        
        self.view.addSubview(filterButton)
        self.filterButton.snp.makeConstraints{ make in
            make.top.equalTo(searchBarView.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(42)
            make.height.equalTo(27)
            make.width.equalTo(63)
        }
        
        self.view.addSubview(segmentControl)
        self.segmentControl.snp.makeConstraints{ make in
            make.centerY.equalTo(filterButton.snp.centerY)
            make.trailing.equalToSuperview().offset(-48)
        }
        
        
        self.view.addSubview(btn)
        btn.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
