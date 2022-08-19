//
//  EditProfileInfoViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/17.
//

import Foundation
import UIKit

class EditProfileInfoViewController: UIViewController {
    
    //MARK: - properties

    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .mainColor
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
    }
    
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: true)
    }
}
