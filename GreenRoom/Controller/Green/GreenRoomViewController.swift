//
//  GreenRoomViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import RxSwift

class GreenRoomViewController: UIViewController {
        let greenRoomViewModel = GreenRoomViewModel()
        let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.subscribe()
    }
    
    func subscribe(){
        greenRoomViewModel.isLogin()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { isToken in
                if isToken {
                    print("자동로그인")
                }else {
                    print("로그인필요")
                    let loginVC = LoginViewController(loginViewModel: LoginViewModel())
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: false)
                }
            }).disposed(by: disposeBag)
    }
}
