//
//  CustomGoalProgressBar.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/26.
//

import UIKit

class CustomProgressBar: UIView {
    //MARK: - Properties
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    private let progressLayer = CAGradientLayer().then{
        $0.colors = [
            UIColor(red: 0.431, green: 0.918, blue: 0.682, alpha: 1).cgColor,
            UIColor(red: 0.341, green: 0.757, blue: 0.718, alpha: 1).cgColor
        ]
        
        $0.locations = [0, 1]
        
        $0.startPoint = CGPoint(x: 0.25, y: 0.5)
        
        $0.endPoint = CGPoint(x: 0.75, y: 0.5)
        
        $0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 15813.06, tx: 0.04, ty: -7906.53))
        
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.196, green: 0.196, blue: 0.196, alpha: 0.2)
        layer.addSublayer(self.progressLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Draw
    override func draw(_ rect: CGRect) {
        let backgroundMask = CAShapeLayer()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.5).cgPath
        layer.mask = backgroundMask
        
        let progressRect = CGRect(origin: .zero,
                                  size: CGSize(width: rect.width * progress, height: rect.height))
        
        progressLayer.frame = progressRect
        progressLayer.speed = 3
        
        progressLayer.bounds = progressRect.insetBy(dx: -0.5*progressRect.width, dy: -0.5*progressRect.height)
        
        progressLayer.position = .zero
    }
    
}
