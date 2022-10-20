//
//  RecentQuestionCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/04.
//
import UIKit

final class RecentQuestionCell: UICollectionViewCell {
    
    static let reuseIdentifer = "RecentQuestionCell"
    
    //MARK: - Properties
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = frame.size.width * 0.08 / 2
        $0.layer.masksToBounds = true
        $0.backgroundColor = .blue
    }
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))

    private lazy var questionLabel = PaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)).then {
        $0.backgroundColor = .white
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
        self.contentView.setMainLayer()
        self.backgroundColor = .white
        self.contentView.addSubview(questionLabel)
        self.questionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.top.equalToSuperview()
            make.height.equalTo(110)
        }
        
        self.contentView.addSubview(categoryLabel)
        self.categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        self.contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-13)
            make.width.height.equalTo(frame.size.width * 0.15)
        }
    }
    
    func configure(question: PublicQuestion){
        
        self.questionLabel.attributedText = question.question.addLineSpacing(foregroundColor: .black)
        
        self.categoryLabel.text = question.categoryName
        guard let url = URL(string: question.profileImage) else { return }
        
        self.profileImageView.kf.setImage(with: url)
        
    }
}

