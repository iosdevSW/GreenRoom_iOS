//
//  PublicAnswerCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//

import UIKit

final class PublicAnswerCell: BaseCollectionViewCell {
    
    static let reuseIdentifier = "PublicAnswerCell"
    
    //MARK: - ProPerties
    var isReversed: Bool = false {
        didSet { isReversed ? configureReverseUI() : configureUI() }
    }
    
    var question: PublicAnswer? {
        didSet { configure() }
    }
    
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = frame.size.width * 0.1 / 2
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "GreenRoomIcon")
        $0.alpha = 0.3
        $0.backgroundColor = .customGray
    }
    
    private var answerLabel = UILabel().then {
        $0.textColor = .customGray
        $0.text = "작성 시 동료의 답변을 볼 수 있어요!\n답변 작성에 참여해주세요 :)"
        $0.numberOfLines = 0
        $0.font = .sfPro(size: 16, family: .Regular)
    }
    
    //MARK: - Configure
    override func configureUI() {
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
    
    private func configureReverseUI() {
        
        let imageSize = frame.size.width * 0.1
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-40)
            make.width.height.equalTo(imageSize)
        }
        self.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalTo(profileImageView.snp.leading).offset(-40)
            make.height.equalTo(60)
        }

    }
    
    private func configure() {
        guard let question = question else { return }
        
        self.profileImageView.kf.setImage(with: URL(string: question.profileImage))
        self.profileImageView.alpha = 1.0
        self.answerLabel.text = question.answer
        self.answerLabel.textColor = .black
        
    }
}
