//
//  PublicAnswerCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//

import UIKit

final class PublicAnswerCell: BaseCollectionViewCell {
    
    //MARK: - ProPerties
    var isReversed: Bool = false {
        didSet { isReversed ? configureOddUI() : configureEvenUI() }
    }
    
    var question: PublicAnswer? {
        didSet { configure() }
    }
    
    private lazy var profileImageView = ProfileImageView()
    
    private var answerLabel = UILabel().then {
        $0.textColor = .customGray
        $0.text = "작성 시 동료의 답변을 볼 수 있어요!\n답변 작성에 참여해주세요 :)"
        $0.numberOfLines = 0
        $0.font = .sfPro(size: 16, family: .Regular)
    }
    
    //MARK: - Configure
    func configureEvenUI() {
        self.backgroundColor = .white
        
        let imageSize = frame.size.width * 0.1
        
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(imageSize)
            make.leading.equalToSuperview().offset(40)
        }

        self.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(40)
            make.trailing.equalToSuperview().offset(-40)
            make.height.equalTo(50)
        }
    }
    
    private func configureOddUI() {
        
        let imageSize = frame.size.width * 0.1
        
        self.addSubviews([profileImageView, answerLabel])
        
        profileImageView.snp.remakeConstraints{ make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-40)
            make.width.height.equalTo(imageSize)
        }
        
        answerLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalTo(profileImageView.snp.leading).offset(-40)
            make.height.equalTo(60)
        }
    }
    
    private func configure() {
        guard let question = question else { return }
        
        self.profileImageView.setImage(at: question.profileImage)
        self.profileImageView.alpha = 1.0
        self.answerLabel.text = question.answer
        self.answerLabel.textColor = .black
        
    }
}
