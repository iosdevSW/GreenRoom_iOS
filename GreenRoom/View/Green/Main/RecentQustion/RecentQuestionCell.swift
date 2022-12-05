//
//  RecentQuestionCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/04.
//
import UIKit

final class RecentQuestionCell: BaseCollectionViewCell {
    
    static let reuseIdentifer = "RecentQuestionCell"
    
    //MARK: - Properties
    private lazy var profileImageView = ProfileImageView()
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))

    private lazy var questionLabel = PaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)).then {
        $0.backgroundColor = .white
        $0.numberOfLines = 0
    }
    
    //MARK: - Configure
    override func configureUI(){
        self.contentView.setMainLayer()
        self.backgroundColor = .white
        
        self.contentView.addSubviews([questionLabel, categoryLabel, profileImageView])
        
        self.categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.leading.trailing.equalToSuperview().inset(13)
        }
        
        self.questionLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.equalTo(categoryLabel.snp.bottom)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.trailing.equalToSuperview().inset(13)
            make.width.height.equalTo(frame.size.width / 6)
        }
    }
    
    func configure(question: GreenRoomQuestion){
        
        self.questionLabel.attributedText = question.question.addLineSpacing(spacing: 6, foregroundColor: .black)
        
        self.categoryLabel.text = question.categoryName
        self.profileImageView.setImage(at: question.profileImage)
    }
}

