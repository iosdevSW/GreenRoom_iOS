//
//  LodingIndicator.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/20.
//

import UIKit

class LodingIndicator: UIView {
    //MARK: - Properites
    private var dotsScale = 3
    
    private var dotLayers = [CAShapeLayer]()
    
    private var diameter = 4 //지름(높이=넓이)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        let middle: Int = 3 / 2
        for (index, layer) in dotLayers.enumerated() {
            let x = center.x + CGFloat(index - middle) * CGFloat(((diameter)+10))
            layer.position = CGPoint(x: x, y: center.y)
            
            setGradient(layer)
        }
    }
    
    /// 도트 레이어 생성하는 메소드
    private func dotLayer(_ diameter: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.cornerRadius = diameter / 2
        layer.bounds = CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
        layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: diameter/2).cgPath
        layer.fillColor = tintColor.cgColor
        
        return layer
    }
    
    /// 도트 레이어 화면에 추가
    private func setupLayers() {
        for _ in 0..<3 {
            let dl = dotLayer(4)
            dotLayers.append(dl)
            layer.addSublayer(dl)
        }
    }
    /// 애니메이션 시작.
    public func startAnimating() {
        var offset :TimeInterval = 0.0
        dotLayers.forEach {
            $0.removeAllAnimations()
            $0.add(scaleAnimation(offset), forKey: "dotScaleAnimate")
            offset = offset + 0.4
        }
    }
    
    /// 애니메이션 정지
    public func stopAnimating() {
        dotLayers.forEach { $0.removeAllAnimations() }
    }
    
    // scaleAnimation
    private func scaleAnimation(_ after: TimeInterval = 0) -> CAAnimationGroup {
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.beginTime = after
        scaleUp.fromValue = 1
        scaleUp.toValue = dotsScale
        scaleUp.duration = 0.3
        scaleUp.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.beginTime = after+scaleUp.duration
        scaleDown.fromValue = dotsScale
        scaleDown.toValue = 1.0
        scaleDown.duration = 0.2
        scaleDown.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        let group = CAAnimationGroup()
        group.animations = [scaleUp, scaleDown]
        group.repeatCount = Float.infinity
        
        let sum = CGFloat(3)*0.2 + CGFloat(0.6)
        group.duration = CFTimeInterval(sum)
        
        return group
    }
    
    private func setGradient(_ layer: CAShapeLayer) {
        let gradientDotLayer = CAGradientLayer()
        gradientDotLayer.cornerRadius = CGFloat(diameter / 2)
        
        gradientDotLayer.colors = [
            UIColor(red: 0.431, green: 0.918, blue: 0.682, alpha: 1).cgColor,
            UIColor(red: 0.341, green: 0.757, blue: 0.718, alpha: 1).cgColor
        ]
        
        gradientDotLayer.locations = [0.0 , 1.0]
        gradientDotLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientDotLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientDotLayer.frame = layer.bounds
        
        layer.insertSublayer(gradientDotLayer, at: 0)
    }
}
