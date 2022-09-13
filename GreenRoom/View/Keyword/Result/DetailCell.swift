//
//  DetailCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/30.
//

import UIKit

class DetailCell: UICollectionViewCell {
    //MARK: - Properties
    var keywordIsOn = false {
        didSet{
            if keywordIsOn {
                self.goalProgressBarView.titleLabel.text = "전체 키워드 매칭률"
            }else {
                self.goalProgressBarView.titleLabel.text = "면접 연습 결과"
                self.goalFrameView.snp.remakeConstraints{ make in
                    make.top.leading.trailing.equalToSuperview()
                    make.height.equalTo(76)
                }
            }
            self.goalProgressBarView.progressBar.isHidden = !keywordIsOn
            self.goalProgressBarView.guideLabel.isHidden = !keywordIsOn
            self.goalProgressBarView.persentLabel.isHidden = !keywordIsOn
        }
    }
    
    let goalFrameView = UIView().then {
        $0.backgroundColor = .customGray.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    let goalProgressBarView = ProgressBarView().then{
        $0.guideLabel.text = "목표까지 5% 남았어요"
        $0.removeGesture()
    }
    
    let categoryLabel = UILabel().then {
        $0.backgroundColor = .customGray
        $0.textColor = .darkGray
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    let questionLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .customDarkGray
        $0.numberOfLines = 0
    }
    
    let keywordPersent = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 16, family: .Semibold)
    }
    
    let warningLabel = UILabel().then {
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textColor = .point
    }
    
    let sttAnswer = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }
    
    let separatorView = UIView().then {
        $0.separatorLine(viewHeight: 26)
    }
    
    let keywordLabel = PaddingLabel(padding: .init(top: 0, left: 8, bottom: 0, right: 8)).then {
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .customGray
        $0.numberOfLines = 0
        $0.backgroundColor = .white
    }
    
    let answerLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .darkGray
        $0.numberOfLines = 0
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(self.goalFrameView)
        self.goalFrameView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(170)
        }
        
        self.goalFrameView.addSubview(self.goalProgressBarView)
        self.goalProgressBarView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.addSubview(self.questionLabel)
        self.questionLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(44)
            make.top.equalTo(goalFrameView.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-80)
        }
        
        self.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(44)
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        self.addSubview(self.keywordPersent)
        self.keywordPersent.snp.makeConstraints{ make in
            make.top.equalTo(goalFrameView.snp.bottom).offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.width.equalTo(40)
        }
        
        self.addSubview(self.warningLabel)
        self.warningLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(44)
            make.top.equalTo(categoryLabel.snp.bottom).offset(7)
        }
        
        self.addSubview(self.sttAnswer)
        self.sttAnswer.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(44)
            make.top.equalTo(warningLabel.snp.bottom).offset(7)
            make.trailing.equalToSuperview().offset(-44)
        }
        
        self.addSubview(self.separatorView)
        self.separatorView.snp.makeConstraints{ make in
            make.height.equalTo(26)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(sttAnswer.snp.bottom).offset(24)
        }
        
        self.addSubview(self.keywordLabel)
        self.keywordLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.centerY.equalTo(self.separatorView.snp.centerY)
        }
        
        self.addSubview(self.answerLabel)
        self.answerLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(44)
            make.top.equalTo(separatorView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-44)
            make.bottom.equalToSuperview()
        }
        
    }
}
