//
//  RegistName.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/04.
//

import UIKit

class RegistNameViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        self.setNavigationItem()
    }
    
    @objc func clickedNextButton(_: UIButton){
        self.navigationController?.pushViewController(RegistCategoryViewController(), animated: true)
    }
    
}


//MARK: - Configure UI
extension RegistNameViewController {
    func configureUI(){
        let nameLabel = UILabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = .sfPro(size: 30, family: .Semibold)
            $0.text = "이름이 무엇인가요?"
            $0.textColor = .black
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(143)
                make.centerX.equalToSuperview()
            }
        }
        
        let textfieldBox = UIView().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 15
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.darken.cgColor
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(nameLabel.snp.bottom).offset(100)
                make.height.equalTo(64)
            }
        }
        
        let nameTextfield = UITextField().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = .customGray
            $0.font = .sfPro(size: 20, family: .Regular)
            $0.attributedPlaceholder = NSAttributedString(string: "이름을 입력해주세요 :)",
                                                          attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray!])
            
            textfieldBox.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(28)
                make.trailing.equalToSuperview().offset(-28)
                make.top.equalToSuperview().offset(15)
                make.bottom.equalToSuperview().offset(-15)
            }
        }
        
        let autoInputButton = UIButton(type: .system).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(.darken, for: .normal)
            $0.titleLabel?.font = .sfPro()
            $0.setTitle("이름 자동입력", for: .normal)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.top.equalTo(textfieldBox.snp.bottom).offset(36)
            }
        }
        
        let nextButton = UIButton(type: .system).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .sfPro(size: 22, family: .Semibold)
            $0.layer.cornerRadius = 15
            $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.backgroundColor = .mainColor
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.bottom.equalToSuperview().offset(-96)
                make.leading.equalToSuperview().offset(36)
                make.trailing.equalToSuperview().offset(-36)
                make.height.equalTo(54)
            }
            $0.addTarget(self, action: #selector(clickedNextButton(_:)), for: .touchUpInside)
        }
    }
    
    override func setNavigationItem() {
        super.setNavigationItem()
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .mainColor
    }
}
