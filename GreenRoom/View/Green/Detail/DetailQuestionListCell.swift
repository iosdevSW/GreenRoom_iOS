//
//  DetailQuestionListCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/07.
//

import Foundation

import UIKit

final class DetailQuestionListCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailQuestionListCell"
    //MARK: - Properties
    var question: Question! {
        didSet {
            configureUI()
        }
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .backgroundGray
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.mainColor.cgColor
    }
    
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = bounds.width * 0.06 / 2
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "GreenRoomIcon")
        $0.tintColor = .mainColor
        $0.layer.masksToBounds = false
    }
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))

    private lazy var questionTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.sizeToFit()
        $0.isScrollEnabled = false
        $0.isUserInteractionEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 6, left: 0, bottom: 5, right:25)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        $0.attributedText = NSAttributedString(
            string: "대부분의 프로젝트는 프로세스는 어떠하며 어떤 롤이 었나요?대부분의 프로젝트는 프로세스는 어떠하며 어떤 롤이 었나요?대부분의 프로젝트는 프로세스는 어떠하며 어떤 롤이 었나요?대부분의 프로젝트는 프로세스는 어떠하며 어떤 롤이 었나요?",
            attributes: [
                NSAttributedString.Key.paragraphStyle : style,
                 NSAttributedString.Key.font: UIFont.sfPro(size: 14, family: .Regular)
                ]
        )
        
        
    }

    private lazy var showContentsButton = ChevronButton()
        
//        .then {
//        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        $0.contentMode = .scaleAspectFill
//        $0.imageView?.tintColor = .gray
//    }
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
        self.backgroundColor = .backgroundGray
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(bounds.width * 0.05)
            make.trailing.equalToSuperview().offset(-bounds.width * 0.05)
        }
        
        self.containerView.addSubview(profileImageView)
        self.containerView.addSubview(categoryLabel)
        self.containerView.addSubview(questionTextView)
        self.containerView.addSubview(showContentsButton)
        
        let margin = self.bounds.width / 20
        
        self.profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(margin)
            make.leading.equalToSuperview().offset(margin)
            make.width.height.equalTo(bounds.width * 0.06)
        }
        
        self.categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(13)
            make.centerY.equalTo(profileImageView.snp.centerY).offset(-3)
        }
        
        self.questionTextView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom)
            make.leading.equalTo(categoryLabel.snp.leading)
            make.bottom.trailing.equalToSuperview()
        }
        
        self.showContentsButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-6)
        }

    }
    
    private func configure(){
        guard let category = CategoryID(rawValue: question.category) else { return }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        
        self.questionTextView.attributedText = NSAttributedString(string: question.question, attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.categoryLabel.text = category.title
        self.profileImageView.image = UIImage(named: question.image)
        
    }
}


