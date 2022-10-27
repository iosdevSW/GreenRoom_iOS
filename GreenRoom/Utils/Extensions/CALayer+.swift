//
//  CALayer+.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/24.
//

import UIKit

extension CALayer {

    func applyShadow(
        color: UIColor = .lightGray,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 4,
        blur: CGFloat = 10
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}

extension UITabBar {
    // 기본 그림자 스타일을 초기화해야 커스텀 스타일을 적용할 수 있다.
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
