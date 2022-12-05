//
//  TempLogin.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/02.
//

import UIKit

class CheckLabel: UIStackView {
    let checkImage = UIImageView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "check") ?? UIImage()
    }
    
    let mainLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .darkGray
    }
    
    let descriptionLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textColor = .customGray
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.addSubview(checkImage)
        checkImage.snp.makeConstraints{ make in
            make.leading.top.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        self.addSubview(mainLabel)
        mainLabel.snp.makeConstraints{ make in
            make.leading.equalTo(checkImage.snp.trailing).offset(10)
            make.trailing.top.equalToSuperview()
            make.height.equalTo(18)
        }
        
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
