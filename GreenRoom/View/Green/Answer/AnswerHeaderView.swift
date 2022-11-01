//
//  AnswerHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/22.
//

import UIKit
import RxSwift

final class AnswerHeaderView: UIView {
    
    static let reuseIdentifier = "AnswerHeaderView"
    
    //MARK: - Properties
    var question: QuestionHeader! {
        didSet { configure() }
    }
    
    private var categoryLabel = PaddingLabel(padding: .init(top: 0, left: 8, bottom: 0, right: 8)).then {
        $0.textColor = .mainColor
        $0.text = "디자인"
        $0.backgroundColor = .white
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.sizeToFit()
    }
    
    private lazy var questionTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 30, left: 30, bottom: 0, right:30)
        $0.sizeToFit()
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.questionTextView.attributedText = self.question.question.addLineSpacing(foregroundColor: .black, font: .sfPro(size: 20, family: .Regular))
        self.categoryLabel.text = question.categoryName
        self.questionTextView.isEditable = question.groupCategoryName.isEmpty
    }
    
    private func configureUI() {
        
        self.backgroundColor = .mainColor

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
