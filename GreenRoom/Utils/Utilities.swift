//
//  Utils.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/17.
//

import Foundation
import UIKit

final class Utilities {
    
    static let shared = Utilities()
    
    private init() { }
    
    enum iconPosition {
        case left
        case right
    }
    
    func textWithIcon(text: String, image: UIImage?,font: UIFont = .sfProText(size: 17, family: .Regular), textColor: UIColor = .customGray, imageColor: UIColor?,iconPosition: iconPosition) -> NSMutableAttributedString{
  
        let attributedString = NSMutableAttributedString(string:"")
        
        let imageAttachment = NSTextAttachment()
        
        if imageColor == nil {
            imageAttachment.image = image?.withRenderingMode(.alwaysOriginal)
        } else {
            imageAttachment.image = image?.withTintColor(imageColor!)
        }
        imageAttachment.bounds = CGRect(x: 0, y: -4, width: 21, height: 21)
        
        switch iconPosition {
        case .left:
            attributedString.append(NSAttributedString(attachment:imageAttachment))
            attributedString.append(NSAttributedString(string: "\(text)  "))
        case .right:
            attributedString.append(NSAttributedString(string: "\(text)  "))
            attributedString.append(NSAttributedString(attachment:imageAttachment))
        }
        
        return attributedString
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let attributedString = NSMutableAttributedString(string: text)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.attributedText = attributedString

        label.sizeToFit()
        return label.frame.height
    }
    
}
