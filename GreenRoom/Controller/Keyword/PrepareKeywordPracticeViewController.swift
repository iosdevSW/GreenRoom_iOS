//
//  PrepareKeywordPracticeViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/24.
//

import UIKit

class PrepareKeywordPracticeViewController: UIViewController{
    //MARK: - Properties
    let viewmodel: KeywordViewModel
    
    var goalFrameView = UIView().then {
        $0.backgroundColor = UIColor(red: 0.196, green: 0.196, blue: 0.196, alpha: 0.05)
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    var goalProgressBarView = ProgressBarView()
    
    let test = UITextField().then{
        $0.keyboardType = .numberPad
    }

    //MARK: - Init
    init(viewmodel: KeywordViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureUI()
        
        self.test.rx.text
            .subscribe(onNext: { string in
                if string == ""{
                    
                }else {
                    let integer = Int(string!)!
                    self.goalProgressBarView.progressBar.progress = CGFloat(integer) / 100.0
                }
                
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - ConfigureUI
    func configureUI(){
        self.view.addSubview(self.goalFrameView)
        self.goalFrameView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(276)
        }
        
        let goalTitleLabel = UILabel().then{
            $0.text = "목표 설정하기"
            $0.textColor = .black
            $0.font = .sfPro(size: 16, family: .Semibold)
            
            self.goalFrameView.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(107)
                make.leading.equalToSuperview().offset(44)
            }
        }
        self.goalFrameView.addSubview(self.goalProgressBarView)
        self.goalProgressBarView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.goalFrameView.addSubview(self.test)
        self.test.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.goalFrameView.snp.bottom).offset(-20)
            make.width.equalTo(80)
            make.height.equalTo(60)
        }
    }
}

extension PrepareKeywordPracticeViewController {
   
}
