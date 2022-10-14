//
//  UIButton+Enable.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/23.
//

import UIKit

extension UIButton{
    
    func setEnableButton(_ isTrue: Bool,color: UIColor = .mainColor){
        self.isEnabled = isTrue
        self.backgroundColor = isTrue ? .mainColor : .customGray
    }
    
    func setMainColorButtonConfigure() {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .sfPro(size: 16, family: .Semibold)
        self.backgroundColor = .mainColor
        self.isHidden = true
        self.tintColor = .white
        self.layer.borderColor = UIColor.mainColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.customGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
