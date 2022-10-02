//
//  PublicAnswerHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//


import UIKit

final class PublicAnswerHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "PublicAnswerHeaderView"
    
    //MARK: - Properties
    private lazy var participantLabel = UILabel().then {
        $0.text = "N명이 참여하고 있습니다."
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 12, family: .Bold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(participantLabel)
        participantLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
    }
}
