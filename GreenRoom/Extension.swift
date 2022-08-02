//
//  Extension.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit

extension UIColor {
    class var mainColor:UIColor? { return UIColor(named: "main") }
    class var sub: UIColor? { return UIColor(named: "sub") }
    class var darken: UIColor? { return UIColor(named: "darken") }
    class var point: UIColor? { return UIColor(named: "point") }
    class var customGray: UIColor? { return UIColor(named: "customGray") }
    class var customDarkGray: UIColor? { return UIColor(named: "customDarkGray") }
}

extension UIView {
    //그라데이션 컬러 입히기
    func gradient() {
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
}
