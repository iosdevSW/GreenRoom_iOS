//
//  CustomDarkView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/04.
//

import UIKit

class CustomDarkView: UIView {
    //MARK: - Properties
    let questionLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .sfPro(size: 22, family: .Regular)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.text = "ss"
    }
    
    let keywordLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .sfPro(size: 22, family: .Semibold)
        $0.text = "천진난만   현실적   적극적"
    }
    
    let startButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named:"RecordingButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    let startLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.text = "준비 완료? 버튼 클릭"
    }
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black.withAlphaComponent(0.7)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ConfigureUI
    private func configureUI() {
        self.addSubview(self.questionLabel)
        self.questionLabel.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }

        self.addSubview(self.keywordLabel)
        self.keywordLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.questionLabel.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(56)
            make.trailing.equalToSuperview().offset(-56)
        }

        self.addSubview(self.startButton)
        self.startButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-47)
            make.width.height.equalTo(84)
        }

        self.addSubview(self.startLabel)
        self.startLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(self.startButton.snp.top).offset(-14)
            make.centerX.equalToSuperview()
        }
    }
    //MARK: -
}
