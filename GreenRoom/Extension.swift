//
//  Extension.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit

extension UIColor {
    class var mainColor:UIColor! { return UIColor(named: "main") ?? UIColor.black }
    class var sub: UIColor! { return UIColor(named: "sub") ?? UIColor.black}
    class var darken: UIColor! { return UIColor(named: "darken") ?? UIColor.black}
    class var point: UIColor! { return UIColor(named: "point") ?? UIColor.black}
    class var customGray: UIColor! { return UIColor(named: "customGray") ?? UIColor.black}
    class var customDarkGray: UIColor! { return UIColor(named: "customDarkGray") ?? UIColor.red}
}

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
    
    func separatorLine(color: UIColor = .customGray, margin: CGFloat = 24, viewHeight: CGFloat){
        let layer = CALayer()
        layer.borderColor = color.cgColor
        layer.borderWidth = 1
        layer.frame = CGRect(x: margin, y: viewHeight/2, width: UIScreen.main.bounds.width-(margin*2), height: 1)
        
        self.layer.addSublayer(layer)
        self.layer.masksToBounds = true        
    }
}

extension UIFont {
    enum TextFamily: String {
        case Bold, Regular
    }
    
    enum Family: String {
        case Bold, Regular, Semibold
    }
    
    static func sfProText(size: CGFloat = 16, family: TextFamily = .Regular)->UIFont!{
        return UIFont(name: "SFProText-\(family)", size: size)
    }
    
    static func sfPro(size: CGFloat = 16, family: Family = .Regular)->UIFont!{
        return UIFont(name: "SFPro-\(family)", size: size)
    }
}

extension UIViewController{
    // 회원가입 네비게이션바 아이템 설정
    @objc func setNavigationItem() {
        let questionButtonItem = UIBarButtonItem(title: "문의사항",
                                                 style: .plain,
                                                 target: self,
                                                 action: nil)
        questionButtonItem.tintColor = .customGray
        self.navigationItem.rightBarButtonItem = questionButtonItem
    }
}
