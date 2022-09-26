//
//  AnswerHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/22.
//

import UIKit

final class AnswerHeaderView: UIView {
    
    static let reuseIdentifier = "AnswerHeaderView"
    
    //MARK: - Properties
    var question: Question! {
        didSet { configure() }
    }
    
    private var categoryLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.text = "디자인"
        $0.backgroundColor = .white
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.sizeToFit()
    }
    
    private lazy var questionTextView = UITextView().then {
        $0.isEditable = false
        $0.textContainerInset = UIEdgeInsets(top: 30, left: 30, bottom: 0, right:30)
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.sizeToFit()
        $0.backgroundColor = .clear
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        
        $0.attributedText = NSAttributedString(string: "입사 5년 후, 10년 후 자신의 모습은 어떨 것이라고 생각합니까?",
                                               attributes: [
                                                NSAttributedString.Key.paragraphStyle : style,
                                                 NSAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Regular)
                                                ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        
        self.questionTextView.attributedText = NSAttributedString(string: question.question,
                                               attributes: [
                                                NSAttributedString.Key.paragraphStyle : style,
                                                 NSAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Regular)
                                                ])
        
        self.categoryLabel.text = (CategoryID(rawValue: self.question.category) ?? .common).title
    }
    
    private func configureUI() {
        self.backgroundColor = .mainColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }

        self.addSubview(questionTextView)
        questionTextView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
