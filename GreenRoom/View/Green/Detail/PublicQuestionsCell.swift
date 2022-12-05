//
//  DetailQuestionListCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/07.
//

import Foundation
import UIKit

/// 특정 질문에 대한 리스트를 보여주는 셀 B4, B10
final class PublicQuestionsCell: BaseCollectionViewCell {

    //MARK: - Properties

    private lazy var containerView = UIView()
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = bounds.width * 0.06 / 2
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "GreenRoomIcon")
        $0.tintColor = .mainColor
    }

    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))
    private let expiredLabel = Utilities.shared.generateLabel(text: "23:59 남음", color: .point, font: .sfPro(size: 12, family: .Bold))

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

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Configure
    override func configureUI(){
        self.backgroundColor = .backgroundGray
        containerView.backgroundColor = .backgroundGray
        containerView.setMainLayer()
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
        self.containerView.addSubview(expiredLabel)

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

        expiredLabel.snp.makeConstraints { make in
            make.centerY.equalTo(categoryLabel)
            make.leading.equalTo(categoryLabel.snp.trailing).offset(8)
        }

        self.showContentsButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-6)
        }
    }

    func configure(question: GreenRoomQuestion){
        
        self.containerView.alpha = question.expired ? 0.5 : 1.0
        
        self.questionTextView.attributedText = question.question.addLineSpacing(foregroundColor: .black)
        self.categoryLabel.text = question.categoryName

        guard let url = URL(string: question.profileImage) else { return }
        self.profileImageView.kf.setImage(with: url)
        self.expiredLabel.text = question.expired ? "답변 종료" : "\(question.remainedTime) 남음"
    }
}


