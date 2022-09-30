//
//  PopularQuestionCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import UIKit

final class PopularQuestionCell: UICollectionViewCell {
    
    static let reuseIdentifer = "PopularQuestionCell"
    //MARK: - Properties
    var question: PopularPublicQuestion! {
        didSet { configure() }
    }

    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = bounds.width * 0.08 / 2
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "GreenRoomIcon")
        $0.tintColor = .mainColor
        $0.layer.masksToBounds = false
    }
    
    private let nameLabel = Utilities.shared.generateLabel(text: "박면접", color: .gray, font: .sfPro(size: 12, family: .Regular))
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Regular))
    private let participantsLabel = Utilities.shared.generateLabel(text: "N명이 참여하고 있습니다.", color: .mainColor, font: .sfPro(size: 12, family: .Bold))
    
    private lazy var questionTextView = UITextView().then {
        $0.backgroundColor = .white
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
        $0.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        $0.attributedText = NSAttributedString(
            string: "대부분의 프로젝트는 프로세스는 어떠하며 어떤 롤이 었나요?",
            attributes: [
                NSAttributedString.Key.paragraphStyle : style,
                NSAttributedString.Key.font: UIFont.sfPro(size: 16, family: .Regular),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ])
        
        $0.isUserInteractionEnabled = false
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.mainColor.cgColor
    }
    
   //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
            super.layoutSubviews()
        }
    //MARK: - Configure
    private func configureUI(){
        self.backgroundColor = .backgroundGray
        
   
        self.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(bounds.width * 0.08)
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(bounds.width * 0.08)
        }
        
        self.contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
        }
        
        self.contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.top.equalToSuperview()
        }
        
        self.contentView.addSubview(participantsLabel)
        participantsLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryLabel.snp.trailing).offset(10)
            make.top.equalToSuperview()
        }

        self.contentView.addSubview(questionTextView)
        questionTextView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(5)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(83)
        }
        
        
    }
    
    private func configure(){
        
        self.nameLabel.text = question.name
        self.questionTextView.text = question.question
        self.categoryLabel.text = question.categoryName
        self.participantsLabel.text = "\(question.participants)명이 참여하고 있습니다."
        
        guard let url = URL(string: question.profileImage) else { return }
        self.profileImageView.kf.setImage(with: url)
        
    }
}
