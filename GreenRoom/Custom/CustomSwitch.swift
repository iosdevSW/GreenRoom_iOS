//
//  CustomSwitch.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit

class CustomSwitch: UIControl {
    //MARK: - Properties
    var animationDuration: TimeInterval = 0.3
    
    private var barView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 20
    }
    private var cameraImageView = UIImageView().then {
        $0.image = UIImage(named: "cameraON")?.withRenderingMode(.alwaysOriginal)
    }
    
    var isOn: Bool = true {
        didSet {
            sendActions(for: .valueChanged)
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                if self.isOn {
                    self.cameraImageView.image = UIImage(named: "cameraON")?.withRenderingMode(.alwaysOriginal)
                    self.barView.backgroundColor = .clear
                    self.onLayout()
                } else {
                    self.cameraImageView.image = UIImage(named: "cameraOFF")?.withRenderingMode(.alwaysOriginal)
                    self.barView.backgroundColor = .white
                    self.offLayout()
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //사용자가 터치하면 호출하여 스위치 토글
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.isOn = !self.isOn
    }
    
    
    private func onLayout(){
        self.cameraImageView.snp.remakeConstraints{ make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    private func offLayout(){
        self.cameraImageView.snp.remakeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }
    
    //MARK: - ConfigureUI
    
    private func configureUI() {
        self.addSubview(self.barView)
        self.barView.snp.makeConstraints{ make in
            make.leading.top.bottom.trailing.equalToSuperview()
        }
        
        self.addSubview(self.cameraImageView)
        onLayout()
    }
    
    
}
