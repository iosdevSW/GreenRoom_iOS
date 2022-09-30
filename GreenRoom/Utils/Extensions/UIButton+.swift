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
}
