//
//  PopularQuestionCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import Foundation
import UIKit

final class PopularQuestionCell: UICollectionViewCell {
    
    static let reuseIdentifer = "PopularQuestionCell"
    //MARK: - Properties
    private lazy var profileImageView = Utilities.shared.generateProfileImage(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
    
    private let nameLabel = Utilities.shared.generateLabel(text: "박면접", color: .customGray, font: .sfPro(size: 12, family: .Regular))
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Regular))
    private let participantsLabel = Utilities.shared.generateLabel(text: "N명이 참여하고 있습니다.", color: .mainColor, font: .sfPro(size: 12, family: .Regular))
    
    private lazy var questionTextView = UITextView().then {
        $0.backgroundColor = .white
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
        $0.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        $0.text = "대부분의 프로젝트는 프로세스는 어떠하며 어떤 롤이 었나요?"
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
    
    //MARK: - Configure
    private func configureUI(){
        self.backgroundColor = .backgroundGary
        
        let userStackView = UIStackView(arrangedSubviews: [profileImageView,nameLabel])
        userStackView.axis = .vertical
        userStackView.spacing = 4
        userStackView.distribution = .equalSpacing
        
        self.addSubview(userStackView)
        userStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(46)
            make.width.equalTo(53)
            make.height.equalTo(75)
        }
        
        let infoStackView = UIStackView(arrangedSubviews: [categoryLabel, participantsLabel])
        infoStackView.axis = .horizontal
        infoStackView.spacing = 8
        infoStackView.distribution = .equalSpacing
        
        self.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(userStackView.snp.trailing).offset(18)
            make.top.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(22)
        }
        
        self.addSubview(questionTextView)
        questionTextView.snp.makeConstraints { make in
            make.leading.equalTo(userStackView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(83)
        }
    }
}
