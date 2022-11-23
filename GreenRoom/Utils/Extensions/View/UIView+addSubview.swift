//
//  UIView+addSubview.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/23.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(self.addSubview)
    }
}
