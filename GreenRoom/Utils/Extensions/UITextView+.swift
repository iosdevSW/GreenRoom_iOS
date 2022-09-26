//
//  UITextView+.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import UIKit

extension UITextView {
    
    func initDefaultText(with text: String, foregroundColor color: UIColor) {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        self.attributedText = NSAttributedString(string: text,
                                               attributes: [
                                                NSAttributedString.Key.paragraphStyle : style,
                                                NSAttributedString.Key.font: UIFont.sfPro(size: 16, family: .Regular),
                                                NSAttributedString.Key.foregroundColor: color
                                               ])
    }
}
