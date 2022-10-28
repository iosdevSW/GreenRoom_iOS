//
//  MyQuestionListCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/09.
//

import UIKit

class MyQuestionListCell: BaseCollectionViewCell {
    
    static let reuseIedentifier = "MyQuestionListCell"
    
    //MARK: - Properties
    private lazy var containerView = UIView()
    
    private lazy var iconImageView = UIImageView().then {
        $0.image = UIImage(named: "scrap")
        $0.tintColor = .customGray
        $0.contentMode = .scaleAspectFill
    }
    
    private var groupCategoryNameLabel = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)).then {
        $0.backgroundColor = .mainColor
        $0.textColor = .white
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.text = "-"
    }
    
    private let groupNameLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold)).then {
        $0.backgroundColor = .mainColor
    }

    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))
    
    private lazy var questionLabel = PaddingLabel(padding: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 6)).then {
        $0.numberOfLines = 0
    }
    

    //MARK: - Configure
    override func configureUI(){
        
        self.backgroundColor = .clear
        self.containerView.backgroundColor = .white
        self.containerView.setMainLayer()
        self.containerView.addSubview(categoryLabel)
        self.containerView.addSubview(questionLabel)
        self.contentView.addSubview(groupCategoryNameLabel)
        self.contentView.addSubview(containerView)
        
        self.containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(bounds.size.height*0.18)
            make.leading.equalToSuperview().offset(bounds.size.width * 0.06)
            make.trailing.equalToSuperview().offset(-bounds.size.width * 0.06)
            make.bottom.equalToSuperview().offset(-10)
        }

        self.categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
        }

        self.questionLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel.snp.leading)
            make.top.equalTo(categoryLabel.snp.bottom)
            make.trailing.equalToSuperview()
        }
        
        self.contentView.addSubview(iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading)
            make.top.equalToSuperview().offset(3)
            make.width.height.equalTo(16)
        }
        
        self.groupCategoryNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
    }
    
    func configure(question: PrivateQuestion){
        self.questionLabel.attributedText = question.question.addLineSpacing(foregroundColor: .black)
        self.categoryLabel.text = question.categoryName
        self.groupNameLabel.text = question.groupName
        self.groupCategoryNameLabel.text = question.groupCategoryName.isEmpty ? "-" : question.groupCategoryName
    }
    
}
