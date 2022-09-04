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
    //MARK: - Properties
    let progressBar = CustomProgressBar()
    private let disposeBag = DisposeBag()
    
    let startingLocationX = 30.0
    
    private let goalFrameView = UIView()
    var goalView = UIView(frame: CGRect(x: -20, y: 0, width: 40, height: 60))
    
    let titleLabel = UILabel().then {
        $0.text = "목표 설정하기"
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .black
    }
    
    let persentLabel = UILabel().then {
        $0.text = "0/100"
        $0.textColor = .customGray
        $0.font = .sfPro(size: 12, family: .Regular)
    }
    
    let guideLabel = UILabel().then {
        $0.text = "목표를 설정해보세요!"
        $0.textColor = .point
        $0.font = .sfPro(size: 12, family: .Regular)
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.setupInputBinding()
        self.drawDottedLine()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Bind
    private func setupInputBinding() {
        let panGesture = UIPanGestureRecognizer()
        goalView.addGestureRecognizer(panGesture)
        panGesture.rx.event.asDriver { _ in .never() }
            .drive(onNext: { [weak self] sender in
                guard let view = self,
                      let frameView = self?.goalFrameView,
                      let senderView = sender.view else {
                    return
                }
                // view에서 움직인 정보
                let transition = sender.translation(in: frameView)
                
                let newX = senderView.center.x + transition.x
                
                if newX >= 0 && newX <= frameView.frame.width {
                    senderView.center = CGPoint(x: newX, y: senderView.center.y)
                    let per = newX/view.progressBar.frame.width
                    view.progressBar.progress = per
                    let persentToString = String(format: "%2.f", per * 100)
                    view.persentLabel.text = persentToString + "/100"
                }
                sender.setTranslation(.zero, in: frameView) // 움직인 값을 0으로 초기화
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Method
    func removeGesture() {
        if let gesture = self.goalView.gestureRecognizers?.first {
            goalView.removeGestureRecognizer(gesture)
        }
    }
    
    private func drawDottedLine(){
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.lineDashPattern = [4,2]
        layer.lineWidth = 1.2
        layer.frame = self.goalView.bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: goalView.frame.origin.y))
        path.addLine(to: CGPoint(x: 20, y: goalView.frame.height))
        
        layer.path = path.cgPath
        goalView.layer.insertSublayer(layer, at: 0)
    }
    
    
    //MARK: - ConfigureUI
    private func configureUI(){
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(44)
        }
        
        self.addSubview(self.goalFrameView)
        self.goalFrameView.addSubview(goalView)
        self.goalFrameView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(startingLocationX)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        
        self.addSubview(self.progressBar)
        self.progressBar.snp.makeConstraints{ make in
            make.height.equalTo(26)
            make.trailing.bottom.leading.equalTo(goalFrameView)
        }
        
        _ = UILabel().then { // 목표 플래그 레이블
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
        
        self.addSubview(guideLabel)
        guideLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.progressBar.snp.bottom).offset(8)
            make.leading.equalTo(self.progressBar.snp.leading).offset(10)
        }
        
        
        self.addSubview(self.persentLabel)
        self.persentLabel.snp.makeConstraints{ make in
            make.top.equalTo(progressBar.snp.bottom).offset(8)
            make.trailing.equalTo(progressBar.snp.trailing).offset(-7)
        }
    }

}
