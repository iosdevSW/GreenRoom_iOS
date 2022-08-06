//
//  LoginViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import RxSwift

class LoginViewModel {
    let loginService: LoginServiceProtocol
    
    func checkUserInfo(token: String){
        
    }
    
    func naverLoginPaser() {
        self.loginService.naverLoginPaser()
    }
    
    func generateRandomName()->Observable<String>{
        return self.loginService.generateRandomName()
    }
    
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
    }
}
