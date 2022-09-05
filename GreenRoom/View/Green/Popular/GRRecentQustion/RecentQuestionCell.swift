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
    var question: Question! {
        didSet {
            configureUI()
        }
    }
    
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = bounds.width * 0.08 / 2
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "GreenRoomIcon")
        $0.tintColor = .mainColor
        $0.layer.masksToBounds = false
    }
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))

    private lazy var questionTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.sizeToFit()
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 5, right:13)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        $0.attributedText = NSAttributedString(string: "대부분의 프로젝트는 프로세스는 어떠하며 어떤 롤이 었나요?", attributes: [NSAttributedString.Key.paragraphStyle : style])
    
        $0.isUserInteractionEnabled = false
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
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.mainColor.cgColor
        
        self.backgroundColor = .white
        self.contentView.addSubview(questionTextView)
        self.questionTextView.snp.makeConstraints { make in
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
            make.top.equalTo(questionTextView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-13)
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

