//
//  GroupCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit

class GroupCell: UITableViewCell {
    //MARK: - Properties
    let categoryLabel = PaddingLabel(padding: .init(top: 0, left: 6, bottom: 0, right: 6)).then{
        $0.backgroundColor = .mainColor
        $0.textColor = .white
        $0.font = .sfPro(size: 12, family: .Semibold)
    }
    
    let groupNameLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .black
    }
    
    let questionCountingLabel = UILabel().then {
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textColor = .black
    }
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        configure()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ConfigureUI
    private func configureUI() {
        self.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(12)
        }
        
        self.addSubview(self.groupNameLabel)
        self.groupNameLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.categoryLabel.snp.bottom).offset(8)
        }
        
        self.addSubview(self.questionCountingLabel)
        self.questionCountingLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.groupNameLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func configure(){
        self.layer.borderColor = UIColor.mainColor.cgColor
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 2
        self.layer.maskedCorners = .init(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner)
    }
}
