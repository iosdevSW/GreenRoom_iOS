//
//  BaseViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/26.
//

import Foundation
import RxSwift

class BaseViewController: UIViewController {
    
    // MARK:- Rx
    var disposeBag = DisposeBag()
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        configureUI()
        setupBinding()
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
    }
    
    func setupAttributes() {
        self.hideKeyboardWhenTapped()
    }
    
    func setupBinding() {
    }
    
    func comfirmAlert(title: String, subtitle: String, completion: @escaping(UIAlertAction) -> Void) -> UIAlertController{
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: completion))
        
        return alert
    }
}


