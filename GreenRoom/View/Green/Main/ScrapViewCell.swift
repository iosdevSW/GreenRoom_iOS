//
//  ScrapViewCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/11.
//

import UIKit

class ScrapViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ScrapViewCell"
    
    //MARK: - Properties
    var question: PublicQuestion! {
        didSet { configure() }
    }
    
    var editMode: Bool = false {
        didSet {
            selectIndicator.isHidden = !editMode
        }
    }
    
    override var isSelected: Bool{
        didSet {
            self.selectIndicator.backgroundColor = self.isSelected ? .mainColor : .white
            self.selectIndicator.setImage(self.isSelected ? UIImage(systemName: "checkmark") : nil, for: .normal)
            self.selectIndicator.layer.borderColor = self.isSelected ? UIColor.white.cgColor : UIColor.customGray.cgColor
        }
    }
    
    private lazy var selectIndicator = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.setImage(UIImage(systemName: "checkmark"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageView?.tintColor = .white
        $0.layer.cornerRadius = 22/2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var containerView = UIView().then {
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.mainColor.cgColor
    }
    
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = bounds.width * 0.2 / 2
        $0.layer.masksToBounds = true
        $0.backgroundColor = .customGray
        $0.tintColor = .mainColor
        $0.layer.masksToBounds = false
    }
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))

    private lazy var questionTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.sizeToFit()
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 13, left: 13, bottom: 5, right:13)
        
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
    }
    
    private var questionStateLabel = UILabel().then {
        $0.textColor = .point
        $0.font = .sfPro(size: 12, family: .Bold)
        $0.text = "답변 완료"
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
        
        let bottomMargin = bounds.height * 0.1
        let sideMargin = bounds.width * 0.07
        
        self.backgroundColor = .white
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        self.containerView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-sideMargin)
            make.bottom.equalToSuperview().offset(-bottomMargin)
            make.width.height.equalTo(bounds.width * 0.2)
        }
        
        self.containerView.addSubview(categoryLabel)
        self.categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(sideMargin)
            make.bottom.equalToSuperview().offset(-bottomMargin)
            make.height.equalTo(25)
        }

        self.containerView.addSubview(questionTextView)
        self.questionTextView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.leading.top.equalToSuperview()
            make.bottom.equalTo(categoryLabel.snp.top)
        }
        
        self.contentView.addSubview(selectIndicator)
        selectIndicator.snp.makeConstraints { make in
            make.leading.equalTo(questionTextView.snp.leading)
            make.top.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        self.contentView.addSubview(questionStateLabel)
        questionStateLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.trailing.equalToSuperview()
        }
        
        selectIndicator.isHidden = true
    }
    
    private func configure(){

        
        self.questionTextView.initDefaultText(with: self.question.question, foregroundColor: .black)

        self.categoryLabel.text = self.question.categoryName
        
        self.alpha = self.question.expired ? 0.3 : 1.0
        self.containerView.backgroundColor = self.question.participated ? .white : .mainColor
        
        guard let url = URL(string: self.question.profileImage) else { return }
        self.profileImageView.kf.setImage(with: url)
        
        self.questionStateLabel.text = self.question.expired ? "답변 종료" : (self.question.participated ? "참여 완료" : "\(self.question.remainedTime) 남음")
    
        self.containerView.backgroundColor = question.expired ? .white : .mainColor
    }
    
}
