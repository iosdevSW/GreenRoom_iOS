//
//  ProgressBarView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/26.
//

import UIKit
import RxCocoa
import RxSwift


class ProgressBarView: UIView {
    let progressBar = CustomProgressBar()
    let startingLocationX = 30.0
    
    var goalView = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 60))
    
    var persentLabel = UILabel().then{
        $0.text = "0/100"
        $0.textColor = .customGray
        $0.font = .sfPro(size: 12, family: .Regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.setupInputBinding()
        self.drawDottedLine()
        self.addSubview(goalView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInputBinding() {
        let panGesture = UIPanGestureRecognizer()
        goalView.addGestureRecognizer(panGesture)
        panGesture.rx.event.asDriver { _ in .never() }
            .drive(onNext: { [weak self] sender in
                guard let view = self,
                      let senderView = sender.view else {
                    return
                }
                // view에서 움직인 정보
                let transition = sender.translation(in: view)
                
                let newX = senderView.center.x + transition.x
                
                if newX >= 30 && newX <= view.frame.width - 30 {
                    senderView.center = CGPoint(x: newX, y: senderView.center.y)
                    let per = (newX-30)/view.progressBar.frame.width
                    view.progressBar.progress = per
                    let persentToString = String(format: "%2.f", per * 100)
                    view.persentLabel.text = persentToString + "/100"
                }
                sender.setTranslation(.zero, in: view) // 움직인 값을 0으로 초기화
                
            })
    }
    
    func drawDottedLine(){
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.lineDashPattern = [4,2]
        layer.lineWidth = 1.2
        layer.frame = self.goalView.bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: goalView.frame.origin.y))
        path.addLine(to: CGPoint(x: 20, y: goalView.frame.height))
        
        layer.path = path.cgPath
        goalView.layer.addSublayer(layer)
    }
    
    func configureUI(){
        self.addSubview(self.progressBar)
        self.progressBar.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(startingLocationX)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalToSuperview().offset(34)
            make.height.equalTo(26)
        }
        
        let goalLabel = UILabel().then{
            $0.text = "목표"
            $0.textColor = .white
            $0.font = .sfPro(size: 12, family: .Semibold)
            $0.backgroundColor = .customDarkGray
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds =  true
            $0.textAlignment = .center
            
            self.goalView.addSubview($0)
            $0.center = CGPoint(x: 0, y: 0)
            $0.frame.size = CGSize(width: 40, height: 20)
        }
        
        UILabel().then{
            $0.text = "목표를 설정해보세요."
            $0.textColor = .point
            $0.font = .sfPro(size: 12, family: .Regular)
            
            self.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(self.progressBar.snp.bottom).offset(8)
                make.leading.equalTo(self.progressBar.snp.leading).offset(10)
            }
        }
        
        self.addSubview(self.persentLabel)
        self.persentLabel.snp.makeConstraints{ make in
            make.top.equalTo(progressBar.snp.bottom).offset(8)
            make.trailing.equalTo(progressBar.snp.trailing).offset(-7)
        }
    }

}
