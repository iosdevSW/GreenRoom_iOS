//
//  CustomPopUpDatePickerController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/18.
//

import UIKit

final class CustomPopUpDatePickerController: BaseViewController {
    
    //MARK: - Properties
    var viewModel: CreateGRViewModel!
    
    private var datePicker = UIDatePicker()
    
    private var blurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .dark)
        $0.alpha = 0.3
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
    
    private lazy var applyButton = UIButton(type: .system).then{
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .mainColor
        $0.addTarget(self, action: #selector(didClickApplyButton(_:)), for: .touchUpInside)
    }
    
    private lazy var cancelButton = UIButton(type: .system).then{
        $0.setTitle("선택취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .customGray
        $0.addTarget(self, action: #selector(didClickCancelButton(_:)), for: .touchUpInside)
    }
    
    init(viewModel: CreateGRViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configure
    override func configureUI(){
        
        self.view.addSubview(blurView)
        self.blurView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        
        self.containerView.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
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
        setTimeLabel.snp.makeConstraints { make in
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
        viewModel.date.subscribe(onNext: { [weak self] date in
            guard let self = self else { return }
            self.setTimeLabel.attributedText = self.getDateAttributeText(minutes: date)
        }).disposed(by: disposeBag)
    }
    //MARK: - Selector
    @objc func didClickCancelButton(_ sender: UIButton) {
        self.viewModel.date.accept(60 * 24)
        self.dismiss(animated: false)
    }
    
    @objc func didClickApplyButton(_ sender: UIButton) {
        self.viewModel.comfirmDate.accept(self.viewModel.date.value)
        self.dismiss(animated: false)
    }
    
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
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "HH:mm"
        
        let minutes = df.string(from: sender.date).components(separatedBy: ":")
            .compactMap { Int($0) }
        
        viewModel.date.accept(minutes[0] * 60 + minutes[1])
    }
}
