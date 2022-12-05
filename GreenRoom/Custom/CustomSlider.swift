//
//  CustomSlider.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/17.
//

import UIKit

class CustomSlider: UISlider {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setThumbImage(UIImage(), for: .normal)
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.customGray.cgColor
        self.layer.masksToBounds = true
        self.setGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: bounds.width, height: 17)
    }
    
    //MARK: - Gradient
    func setGradient() {
        let layer = CAGradientLayer()
        
        let frame = CGRect.init(x:0, y:0, width:self.frame.size.width, height:17)
        
        layer.frame = frame
        
        layer.locations = [0, 1]
        
        layer.colors = [
            UIColor(red: 0.431, green: 0.918, blue: 0.682, alpha: 1).cgColor,
            UIColor(red: 0.341, green: 0.757, blue: 0.718, alpha: 1).cgColor
        ]
        
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            self.setMinimumTrackImage(image, for: .normal)
        }
    }
}
