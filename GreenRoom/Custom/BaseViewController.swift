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
        setupAttributes()
        configureUI()
        setData()
        setupBinding()
    }
    
    func configureUI() {
        // Override Layout
    }
    
    func setupAttributes() {
        // Override Attributes
    }
    
    func setData() {
        // Override Set Data
    }
    
    func setupBinding() {
        // Override Binding
    }
}
