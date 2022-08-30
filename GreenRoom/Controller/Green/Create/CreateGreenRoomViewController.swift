//
//  CreateGreenRoomViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import UIKit

final class CreateGreenRoomViewController: BaseViewController {
    
    private let subtitleLabel = UILabel().then {
        $0.attributedText = Utilities.shared.textWithIcon(text: "모두가 볼 수 있는 질문입니다.", image: UIImage(named:"createQuestionList"), font: .sfPro(size: 12, family: .Regular), textColor: .gray, imageColor: .customGray, iconPosition: .left)
    }
    
    private let titleLabel = Utilities.shared.generateLabel(text: "질문과 기간을\n선택해주세요.", color: .black, font: .sfPro(size: 30, family: .Regular))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .mainColor
        
    }
    override func configureUI() {
        self.view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissal))
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(titleLabel)
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
        }
    }
    
    override func setupAttributes() {
        
    }
    
    @objc func dismissal(){
        self.dismiss(animated: false)
    }
}
