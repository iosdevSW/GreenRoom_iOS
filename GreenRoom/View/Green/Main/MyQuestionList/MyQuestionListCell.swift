//
//  MyQuestionListCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/09.
//

import UIKit

class MyQuestionListCell: UICollectionViewCell {
    
    static let reuseIedentifier = "MyQuestionListCell"
    
    var question: PrivateQuestion! {
        didSet { configure() }
    }
    
    private lazy var iconImageView = UIImageView().then {
        $0.image = UIImage(named: "scrap")
        $0.tintColor = .customGray
        $0.contentMode = .scaleAspectFill
    }
    
    private var groupCategoryNameLabel = UILabel().then {
        $0.backgroundColor = .mainColor
        $0.textColor = .white
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.text = "-"
    }
    
    private let groupNameLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold)).then {
        $0.backgroundColor = .mainColor
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.mainColor.cgColor
    }
    
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .mainColor
        $0.layer.masksToBounds = false
        $0.backgroundColor = .customGray
    }
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))
    
    private lazy var questionLabel = PaddingLabel(padding: UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 6)).then {
        $0.numberOfLines = 0
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configureUI(){
        
        self.backgroundColor = .clear
        
        self.containerView.addSubview(profileImageView)
        self.containerView.addSubview(categoryLabel)
        self.containerView.addSubview(questionLabel)
        self.contentView.addSubview(groupCategoryNameLabel)
        self.contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(bounds.size.height*0.18)
            make.leading.equalToSuperview().offset(bounds.size.width * 0.06)
            make.trailing.equalToSuperview().offset(-bounds.size.width * 0.06)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        let size = frame.size.width / 15
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(size)
        }
        
        profileImageView.layer.cornerRadius = size / 2

        self.categoryLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }

        self.questionLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel.snp.leading)
            make.top.equalTo(categoryLabel.snp.bottom)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.leading)
            make.top.equalToSuperview().offset(3)
            make.width.height.equalTo(16)
        }
        
        
        groupCategoryNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
            make.centerY.equalTo(iconImageView.snp.centerY)
        }
    }
    
    private func configure(){
        self.questionLabel.attributedText = question.question.addLineSpacing(foregroundColor: .black)
        self.categoryLabel.text = question.categoryName
        self.groupNameLabel.text = question.groupName
        self.groupCategoryNameLabel.text = question.groupCategoryName
    }
    
}
