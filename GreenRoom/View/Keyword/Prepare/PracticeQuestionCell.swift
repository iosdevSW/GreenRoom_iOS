//
//  PracticeQuestionCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/27.
//

import UIKit

class PracticeQuestionCell: UITableViewCell {
    //MARK: - Properties
    let numberLabel = UILabel().then {
        $0.textColor = .customGray
        $0.font = .sfPro(size: 12, family: .Semibold)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .sfPro(size: 20, family: .Regular)
        $0.numberOfLines = 0
    }
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(numberLabel)
        numberLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(25)
            make.height.equalTo(22)
            make.top.equalToSuperview().offset(20)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(numberLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-60)
            make.bottom.equalToSuperview().offset(-23)
        }
    }
}
