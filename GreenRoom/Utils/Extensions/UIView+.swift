//
//  UIView+Layer.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/23.
//

import UIKit

extension UIView {
    //그라데이션 컬러 입히기
    func setGradientColor() {
        let layer = CAGradientLayer()
        
        layer.colors = [
            UIColor(red: 0.431, green: 0.918, blue: 0.682, alpha: 1).cgColor,
            UIColor(red: 0.341, green: 0.757, blue: 0.718, alpha: 1).cgColor
        ]
        
        layer.locations = [0, 1]
        
        layer.startPoint = CGPoint(x: 0.25, y: 0.5)
        
        layer.endPoint = CGPoint(x: 0.75, y: 0.5)
        
        layer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 15813.06, tx: 0.04, ty: -7906.53))
        
        layer.bounds = self.bounds.insetBy(dx: -0.5*self.bounds.size.width, dy: -0.5*self.bounds.size.height)
        
        layer.position = self.center
        
        self.layer.addSublayer(layer)
    }
    
    func setGradient(color1: UIColor = .init(red: 110/255.0, green: 234/255.0, blue: 174/255.0, alpha: 1.0)
                     ,color2:UIColor = .init(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1.0)){
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
    func separatorLine(color: UIColor = .customGray, margin: CGFloat = 24, viewHeight: CGFloat){
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.frame = CGRect(x: margin, y: viewHeight/2, width: UIScreen.main.bounds.width-(margin*2), height: 1)
        
        self.layer.addSublayer(layer)
        self.layer.masksToBounds = true
    }
}

