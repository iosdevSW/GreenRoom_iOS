//
//  UITextView+.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import UIKit

extension UITextView {
    
    func initDefaultText(with text: String, foregroundColor color: UIColor,
                         font: UIFont = .sfPro(size: 16, family: .Regular)) {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        self.attributedText = NSAttributedString(string: text,
                                               attributes: [
                                                NSAttributedString.Key.paragraphStyle : style,
                                                NSAttributedString.Key.font: font,
                                                NSAttributedString.Key.foregroundColor: color
                                               ])
    }
}
