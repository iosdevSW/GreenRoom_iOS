//
//  CustomRecordingButton.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/04.
//

import UIKit

class CustomRecordingButton: UIButton {
    let ringWidth: CGFloat = 10
    
    private let indicatorLayer = CAShapeLayer()
    
    private let animateLayer = CABasicAnimation(keyPath: "location").then {
        $0.fromValue = [-0.3, -0.15, 0]
        $0.toValue = [1, 1.15, 1.3]
        $0.isRemovedOnCompletion = false
        $0.repeatCount = .infinity
        $0.duration = 1
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .mainColor.withAlphaComponent(0.3)
        layer.addSublayer(self.indicatorLayer)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * CGFloat.pi
        
        rotationAnimation.duration = 2
        rotationAnimation.repeatCount = HUGE
        
        indicatorLayer.add(rotationAnimation, forKey: "rotate")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let backgroundMask = CAShapeLayer()
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        
        layer.mask = backgroundMask
        indicatorLayer.strokeColor = UIColor.mainColor.cgColor
        indicatorLayer.fillColor =  UIColor.clear.cgColor
        indicatorLayer.lineWidth = ringWidth
        indicatorLayer.lineCap = .round
        indicatorLayer.frame = rect
        indicatorLayer.strokeEnd = 0.2
        indicatorLayer.path = circlePath.cgPath
    }
}
