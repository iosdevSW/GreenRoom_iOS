//
//  UITextField.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/20.
//

import UIKit

extension UITextField {
    
    func setLeftIcon(_ icon: UIImage?, tintColor: UIColor) {
        
        let padding = 8
        let size = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding*2, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        iconView.tintColor = tintColor
        leftView = outerView
        leftViewMode = .always
    }
}

