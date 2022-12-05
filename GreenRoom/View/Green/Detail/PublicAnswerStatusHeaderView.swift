//
//  PublicAnswerStatusHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//

import UIKit

final class PublicAnswerStatusHeaderView: BaseCollectionReusableView {
    
    var question: DetailPublicQuestionDTO! {
        didSet { configure() }
    }
    
    //MARK: ProPerties
    private let participantsLabel = Utilities.shared.generateLabel(text: "N명이 참여하고 있어요", color: .mainColor, font: .sfPro(size: 12, family: .Semibold))
    
    private let statusLabel = PaddingLabel(padding: UIEdgeInsets(top: 20, left: 29, bottom: 20, right: 29)).then {
        $0.textColor = .customGray
        $0.font = .sfPro(size: 16, family: .Bold)
        $0.text = "작성 시 동료의 답변을 볼 수 있어요!"
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 15
        $0.textAlignment = .center
    }

    //MARK: - Configure
    override func configureUI() {
        self.backgroundColor = .white
        
        let margin = frame.size.width * 0.08
        
        self.addSubview(participantsLabel)
        participantsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        self.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().offset(-margin)
            make.top.equalTo(participantsLabel.snp.bottom).offset(15)
            make.height.equalTo(50)
        }
    }
    
    private func configure() {
        self.participantsLabel.text = "\(question.participants)명이 참여하고 있어요."
        self.statusLabel.text = question.mode.title
    }
}
