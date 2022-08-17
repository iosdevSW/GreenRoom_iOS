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
    
    private lazy var backbutton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.imageView?.tintColor = .mainColor
        $0.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
    }
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .mainColor
        navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }
    func configureUI(){
        view.backgroundColor = .white
        
    }
    
    @objc func handleDismissal(){
        navigationController?.popViewController(animated: true)
    }
}
