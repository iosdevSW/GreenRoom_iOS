//
//  Extension+UIFont.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/23.
//

import UIKit

extension UIFont {
    
    enum TextFamily: String {
        case Bold, Regular
    }
    
    enum Family: String {
        case Bold, Regular, Semibold
    }
    
    static func sfProText(size: CGFloat = 16, family: TextFamily = .Regular) -> UIFont {
        return UIFont(name: "SFProText-\(family)", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
    
    static func sfPro(size: CGFloat = 16, family: Family = .Regular) -> UIFont {
        return UIFont(name: "SFPro-\(family)", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }
}
