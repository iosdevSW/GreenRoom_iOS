//
//  CustomSegmentedControl.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/21.
//

import UIKit

class CustomSegmentedControl: UIView {
    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    var textColor: UIColor = .customGray
    var selectorViewColor: UIColor = .mainColor
    var selectorTextColor: UIColor = .mainColor
    
    init(frame: CGRect,buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        updateView()
    }
    
    func configuStackView(){
        let stackView = UIStackView(arrangedSubviews: buttons).then{
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillProportionally
            
            self.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.bottom.leading.trailing.equalToSuperview()
            }
        }
        let view = UIView()
        stackView.insertArrangedSubview(view, at: 1)
        view.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
    }
    
//    private func configSelectorView() {
//        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
//        selectorView = UIView(frame: CGRect(x: 0,
//                                            y: self.frame.height,
//                                            width: selectorWidth,
//                                            height: 2))
//        selectorView.backgroundColor = selectorViewColor
//        addSubview(selectorView)
//    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach{$0.removeFromSuperview()}
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
            button.backgroundColor = .white
            button.layer.borderColor = selectorViewColor.cgColor
            button.layer.cornerRadius = 15
            button.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
            button.layer.shadowOpacity = 1
            button.layer.shadowOffset = CGSize(width: 0, height: 5)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        buttons[0].layer.borderWidth = 2
    }
    
    @objc func buttonAction(sender: UIButton) {
        for (btnIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            btn.titleLabel?.font = .sfPro(size: 16, family: .Semibold)
            btn.layer.borderWidth = 0
            if btn == sender {
                btn.layer.borderWidth = 2
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
    
    private func updateView() {
        createButton()
//        configSelectorView()
        configuStackView()
    }
    
    
    
}
