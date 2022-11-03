//
//  CustomPopUpDatePickerController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/18.
//

import UIKit
import RxSwift

final class CustomPopUpDatePickerController: BaseViewController {
    
    //MARK: - Properties
    let datePicker = UIDatePicker()
    
    private var blurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .dark)
        $0.alpha = 0.3
        $0.isHidden = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "기간설정"
        $0.textColor = .black
        $0.font = .sfPro(size: 16, family: .Semibold)
    }
    
    private let subtitle = UILabel().then {
        $0.text = "답변기간은 24시간 이내로만 설정할 수 있어요 :)"
        $0.textColor = .point
        $0.font = .sfPro(size: 12, family: .Regular)
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }
    
    private var setTimeLabel = UILabel().then {
        let hour = String(format: "%02d", 24)
        let minutes = String(format: "%02d", 0)
        
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.sfPro(size: 40, family: .Bold),
            .foregroundColor: UIColor.init(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1)
        ]
        
        let mutableAttributeString = NSMutableAttributedString(string: "\(hour)시간 \(minutes)분", attributes: attribute)
        
        let plainAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.sfPro(size: 30, family: .Regular),
            .foregroundColor: UIColor.black
        ]
        
        mutableAttributeString.addAttributes(plainAttribute, range: NSRange(location: 2, length: 2))
        mutableAttributeString.addAttributes(plainAttribute, range: NSRange(location: 7, length: 1))
        $0.attributedText = mutableAttributeString
    }
    
    lazy var applyButton = UIButton(type: .system).then{
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .mainColor
    }
    
    private lazy var cancelButton = UIButton(type: .system).then{
        $0.setTitle("선택취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .customGray
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.blurView.isHidden = false
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.blurView.isHidden = true
    }
    
    //MARK: - Configure
    override func configureUI(){
        
        self.view.addSubview(blurView)
        self.blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(containerView)
        self.containerView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        
        self.containerView.addSubview(datePicker)
        self.datePicker.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        self.containerView.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints{ make in
            make.top.leading.equalToSuperview().offset(41)
        }
        
        self.containerView.addSubview(subtitle)
        self.subtitle.snp.makeConstraints{ make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        self.containerView.addSubview(setTimeLabel)
        self.setTimeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subtitle.snp.bottom).offset(30)
        }
        
        self.containerView.addSubview(cancelButton)
        self.cancelButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        
        self.containerView.addSubview(applyButton)
        self.applyButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalTo(cancelButton.snp.trailing).offset(20)
            make.height.equalTo(60)
        }
    }
    
    override func setupAttributes() {
        configureDatePicker()
    }
    
    override func setupBinding() {
        self.datePicker.rx.controlEvent(.valueChanged)
            .withUnretained(self)
            .map { onwer, _ in
                onwer.datePicker.date.getMinutes()
            }
            .withUnretained(self)
            .map { onwer, date in
                self.getDateAttributeText(minutes: date)
            }
            .bind(to: self.setTimeLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        self.cancelButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { onwer, _ in
                onwer.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        self.applyButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { onwer, _ in
                onwer.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Selector
    private func getDateAttributeText(minutes: Int) -> NSMutableAttributedString {
        let hour = String(format: "%02d", minutes/60)
        let minutes = String(format: "%02d", minutes%60)
        
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.sfPro(size: 40, family: .Bold),
            .foregroundColor: UIColor.init(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1)
        ]
        
        let mutableAttributeString = NSMutableAttributedString(string: "\(hour)시간 \(minutes)분", attributes: attribute)
        
        let plainAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.sfPro(size: 30, family: .Regular),
            .foregroundColor: UIColor.black
        ]
        
        mutableAttributeString.addAttributes(plainAttribute, range: NSRange(location: 2, length: 2))
        mutableAttributeString.addAttributes(plainAttribute, range: NSRange(location: 7, length: 1))
        return mutableAttributeString
    }
}

//MARK: - UIDatePicker
extension CustomPopUpDatePickerController {
    
    func configureDatePicker() {
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.datePickerMode = .countDownTimer
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.datePicker.timeZone = .autoupdatingCurrent
    }
}
