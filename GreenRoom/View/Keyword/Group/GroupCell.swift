//
//  GroupCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit

class GroupCell: UITableViewCell {
    //MARK: - Properties
    private let frameView = UIStackView().then {
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 2
        $0.layer.maskedCorners = .init(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner)
    }
    
    let categoryLabel = PaddingLabel(padding: .init(top: 2, left: 10, bottom: 2, right: 10)).then{
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
    
    let editButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "QNA")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
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
        self.addSubview(self.frameView)
        self.frameView.snp.makeConstraints{ make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.frameView.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(12)
        }
        
        self.frameView.addSubview(self.groupNameLabel)
        self.groupNameLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.categoryLabel.snp.bottom).offset(8)
        }
        
        self.frameView.addSubview(self.questionCountingLabel)
        self.questionCountingLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(self.groupNameLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        self.frameView.addSubview(self.editButton)
        self.editButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(20)
        }
    }
    
    func configure(){
        
    }
}
