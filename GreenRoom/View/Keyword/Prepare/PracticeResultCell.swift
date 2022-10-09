//
//  PracticeResultCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/30.
//

import UIKit

class PracticeResultCell: UITableViewCell {
    //MARK: - Properties
    let questionLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .customDarkGray
        $0.numberOfLines = 0
    }
    
    let categoryLabel = PaddingLabel(padding: .init(top: 0, left: 8, bottom: 0, right: 8)).then {
        $0.backgroundColor = .customGray.withAlphaComponent(0.8)
        $0.textColor = .darkGray
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    let keywordsLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .customGray
    }
    
    let keywordPersent = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 16, family: .Semibold)
    }
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ConfigureUI
    func configureUI() {
        self.addSubview(keywordPersent)
        keywordPersent.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.width.equalTo(40)
        }
        
        self.addSubview(questionLabel)
        questionLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalTo(keywordPersent.snp.leading).offset(-50)
        }
        
        self.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(44)
//            make.width.equalTo(40)
            make.height.equalTo(20)
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
        }
        
        self.addSubview(keywordsLabel)
        keywordsLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalToSuperview().offset(-40)
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
}
