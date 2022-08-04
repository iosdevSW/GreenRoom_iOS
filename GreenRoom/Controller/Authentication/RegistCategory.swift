//
//  RegistCategory.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/04.
//

import UIKit

class RegistCategoryViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setNavigationItem()
        configureUI()
    }
}

//MARK: - Configure UI
extension RegistCategoryViewController {
    func configureUI(){
        let label = UILabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 2
            $0.text = "관심 있는 면접 항목을 골라주세요!"
            $0.textAlignment = .center
            $0.font = .sfPro(size: 30, family: .Semibold)
            $0.textColor = .black
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(114)
                make.width.equalTo(270)
                make.centerX.equalToSuperview()
            }
        }
    }
    override func setNavigationItem() {
        super.setNavigationItem()
    }
    
}
