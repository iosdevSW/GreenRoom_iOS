//
//  ChevronButton.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/02.
//

import UIKit

class ChevronButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        _ = UIImageView().then {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .white
            
            self.addSubview($0)
            $0.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-20)
                make.width.equalTo(12)
                make.height.equalTo(18)
                make.centerY.equalToSuperview()
            }
        }
    }
    
    func setConfigure(title: String, bgColor: UIColor, radius: CGFloat){
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            var titleAttr = AttributedString.init(title)
            titleAttr.font = .sfPro(size: 20, family: .Semibold)
            titleAttr.foregroundColor = UIColor.white
            
            config.attributedTitle = titleAttr
            config.titlePadding = 20
            config.baseBackgroundColor = bgColor
            config.background.cornerRadius = radius
            
            self.configuration = config
        } else {
            self.titleEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
            self.backgroundColor = bgColor
            self.layer.cornerRadius = radius
            self.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
            self.setTitle(title, for: .normal)
            self.setTitleColor(.white, for: .normal)
        }
        
        self.contentHorizontalAlignment = .left
    }
}
