//
//  TimeOutView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/03.
//

import UIKit

final class TimeOutView: UIView {
    
    private lazy var timeLabel = UILabel().then {
        $0.textColor = .point
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 110, height: 45))
        
        self.drawTips()
        self.configureUI()
        self.configureLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.backgroundColor = .white
        
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configureLayer() {
        
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowPath = nil
        self.layer.masksToBounds = false
    }

    private func drawTips() {
        let path = CGMutablePath()

        let tipWidthCenter = 20 / 2.0
        let tipStartX = self.bounds.width / 2 - tipWidthCenter

        let endXWidth = tipStartX + 20
        path.move(to: CGPoint(x: tipStartX, y: 45))
        path.addLine(to: CGPoint(x: tipStartX + tipWidthCenter, y: 45 + CGFloat(8)))
        path.addLine(to: CGPoint(x: endXWidth, y: 45))

        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.white.cgColor

        self.layer.insertSublayer(shape, at: 0)
    }
    
    func configure(time: String) {
        let remainedTime = Date().getRemainedTime(date: time)
        self.isHidden = remainedTime.hasPrefix("-")
        self.timeLabel.text = remainedTime + " 남음"
    }
}
