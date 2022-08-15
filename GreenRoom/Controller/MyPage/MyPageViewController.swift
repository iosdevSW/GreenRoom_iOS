//
//  MyPageViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import SwiftKeychainWrapper

class MyPageViewController: UIViewController {
    let btn = UIButton(type: .roundedRect).then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("logout", for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        btn.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
    }
 
    func configureUI(){
        self.view.addSubview(btn)
        btn.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
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
