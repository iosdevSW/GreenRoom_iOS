//
//  PopularQuestionCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import UIKit

final class PopularQuestionCell: BaseCollectionViewCell {
    
    static let reuseIdentifer = "PopularQuestionCell"
    //MARK: - Properties
    
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = self.frame.width / 20
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "CharacterProfile1")
        $0.tintColor = .mainColor
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "박면접"
        $0.textColor = .gray
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textAlignment = .center
    }
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Regular))
    private let participantsLabel = Utilities.shared.generateLabel(text: "N명이 참여하고 있습니다.", color: .mainColor, font: .sfPro(size: 12, family: .Bold))
    private let expiredLabel = Utilities.shared.generateLabel(text: "23:59 남음", color: .point, font: .sfPro(size: 12, family: .Bold))
    
    private lazy var questionLabel = PaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)).then {
        $0.backgroundColor = .white
        $0.numberOfLines = 0
        $0.setMainLayer()
    }
    
    //MARK: - LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Configure
    override func configureUI(){
        self.backgroundColor = .backgroundGray
        
        self.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(frame.width/10)
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(frame.width / 20)
        }
        
        self.contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.top.equalToSuperview()
        }
        
        self.contentView.addSubview(participantsLabel)
        participantsLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel.snp.trailing).offset(10)
            make.centerY.equalTo(categoryLabel)
        }
        
        self.contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(83)
        }
        
        self.contentView.addSubview(expiredLabel)
        expiredLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(questionLabel.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalTo(questionLabel.snp.leading).offset(-4)
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
        }
    }
    
    func configure(question: PopularGreenRoomQuestion){
        self.nameLabel.text = question.name
        self.questionLabel.attributedText = question.question.addLineSpacing(foregroundColor: .black)
        self.categoryLabel.text = question.categoryName
        self.participantsLabel.text = "\(question.participants)명이 참여하고 있습니다."
        self.profileImageView.kf.setImage(with: URL(string: question.profileImage))
        self.expiredLabel.text = "\(question.remainedTime) 남음"
    }
}
