//
//  KPGreenRoomListCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/11/06.
//

import UIKit

class KPGreenRoomListCell: UITableViewCell {
    //MARK: - Properties
    private let frameView = UIView().then {
        $0.setMainLayer()
        $0.backgroundColor = .white
    }
    
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = frame.size.width / 12
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "CharacterProfile1")
    }
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))

    private lazy var questionLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
   //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configureUI(){
        self.contentView.addSubview(frameView)
        self.frameView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.frameView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(frame.size.width / 6)
        }
        
        self.frameView.addSubview(categoryLabel)
        self.categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(self.profileImageView.snp.centerY).offset(-6)
        }
        
        self.frameView.addSubview(questionLabel)
        self.questionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(10)
            make.top.equalTo(self.categoryLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(question: KPGreenRoomQuestion){
        
        self.questionLabel.attributedText = question.question.addLineSpacing(foregroundColor: .black)
        
        self.categoryLabel.text = question.categoryName
        guard let url = URL(string: question.profileImage) else { return }
        
        self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named:"CharacterProfile1"))
        
    }

}
