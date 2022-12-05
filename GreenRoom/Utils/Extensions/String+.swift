//
//  String+.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/07.
//

import UIKit

extension String {
    
    func addLineSpacing(spacing: CGFloat = 8, foregroundColor color: UIColor,
                        font: UIFont = .sfPro(size: 16, family: .Regular)) -> NSAttributedString {
       
       let style = NSMutableParagraphStyle()
       style.lineSpacing = spacing
       
       return NSAttributedString(string: self,
                                              attributes: [
                                               NSAttributedString.Key.paragraphStyle : style,
                                               NSAttributedString.Key.font: font,
                                               NSAttributedString.Key.foregroundColor: color
                                              ])
   }
}
