//
//  Extension+UIColor.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/23.
//

import UIKit

extension UIColor {
    class var mainColor:UIColor! { return UIColor(named: "main") ?? UIColor.black }
    class var sub: UIColor! { return UIColor(named: "sub") ?? UIColor.black}
    class var darken: UIColor! { return UIColor(named: "darken") ?? UIColor.black}
    class var point: UIColor! { return UIColor(named: "point") ?? UIColor.black}
    class var customGray: UIColor! { return UIColor(named: "customGray") ?? UIColor.black}
    class var customDarkGray: UIColor! { return UIColor(named: "customDarkGray") ?? UIColor.red}
    
    static let backgroundGray = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
}

