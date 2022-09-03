//
//  KPGroupEditViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit

class KPGroupEditViewController: BaseViewController {
    //MARK: - Properties
    
    //MARK: - Init
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        let imageView = UIImageView(image: .init(named: "folder")).then {
            $0.tintColor = .customGray
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(32)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                make.width.equalTo(14)
                make.width.equalTo(12)
            }
        }
        
        let subLabel = UILabel().then {
            $0.text = "그룹을 만들어 질문을 관리하세요."
            $0.textColor = .customGray
            $0.font = .sfPro(size: 12, family: .Regular)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalTo(imageView.snp.trailing).offset(6)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            }
        }
        
        let guideLabel = UILabel().then {
            $0.numberOfLines = 2
            $0.font = .sfPro(size: 30, family: .Regular)
            $0.textColor = .black
            $0.text = "그룹 내용을\n작성해주세요"
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(32)
                make.top.equalTo(subLabel.snp.bottom).offset(4)
            }
        }
        
        let inputNameLable = UILabel().then {
            $0.text = "이름입력"
            $0.font = .sfPro(size: 12, family: .Regular)
            $0.textColor = .customGray
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(32)
                make.top.equalTo(guideLabel.snp.bottom).offset(38)
            }
        }
        
    }
}
