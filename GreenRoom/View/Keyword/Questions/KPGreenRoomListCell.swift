//
//  KPGreenRoomListCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/11/06.
//

import UIKit

class KPGreenRoomListCell: UITableViewCell {
    //MARK: - Properties
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = frame.size.width / 12
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "CharacterProfile1")
    }
    
    private let categoryLabel = Utilities.shared.generateLabel(text: "디자인", color: .black, font: .sfPro(size: 12, family: .Semibold))

    private lazy var questionLabel = PaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)).then {
        $0.backgroundColor = .white
        $0.numberOfLines = 0
    }
    
   //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configureUI(){
        self.contentView.setMainLayer()
        self.backgroundColor = .white
        self.contentView.addSubview(questionLabel)
        self.questionLabel.snp.makeConstraints { make in
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
            make.top.equalTo(questionLabel.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-13)
            make.width.height.equalTo(frame.size.width / 6)
        }
    }
    
    func configure(question: KPGreenRoomQuestion){
        
        self.questionLabel.attributedText = question.question.addLineSpacing(foregroundColor: .black)
        
        self.categoryLabel.text = question.categoryName
        guard let url = URL(string: question.profileImage) else { return }
        
        self.profileImageView.kf.setImage(with: url, placeholder: UIImage(named:"CharacterProfile1"))
        
    }

}
