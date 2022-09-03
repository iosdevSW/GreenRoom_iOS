//
//  ReviewCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/31.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    //MARK: - Properties
    let frameView = UIView().then {
        $0.backgroundColor = .customGray
        $0.layer.cornerRadius = 15
    }
    
    let questionLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    let categoryLabel = UILabel().then {
        $0.backgroundColor = .customGray
        $0.textColor = .darkGray
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    let keywordPersent = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 16, family: .Semibold)
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(self.frameView)
        self.frameView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(500)
        }
        
        self.addSubview(self.keywordPersent)
        self.keywordPersent.snp.makeConstraints{ make in
            make.top.equalTo(frameView.snp.bottom).offset(28)
            make.trailing.equalToSuperview().offset(-44)
        }
        
        self.addSubview(self.questionLabel)
        self.questionLabel.snp.makeConstraints{ make in
            make.top.equalTo(frameView.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalTo(self.keywordPersent.snp.leading).offset(-10)
            
        }
        
        self.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.questionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(44)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
    }
}
