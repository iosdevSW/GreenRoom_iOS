//
//  CreateGRHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/17.
//

import UIKit
import RxSwift
import RxGesture

final class CreateGRHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "CreateGRHeaderView"
    
    //MARK: - Properties
    private var disposeBag = DisposeBag()
    
    private let subtitleLabel = UILabel().then {
        $0.attributedText = Utilities.shared.textWithIcon(text: "모두가 볼 수 있는 질문입니다.", image: UIImage(named:"createQuestionList"), font: .sfPro(size: 12, family: .Regular), textColor: .customGray, imageColor: .customGray, iconPosition: .left)
    }
    
    private let titleLabel = Utilities.shared.generateLabel(text: "질문과 기간을\n선택해주세요.", color: .black, font: .sfPro(size: 30, family: .Regular))
    
    lazy var questionTextView = UITextView().then {
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.text = "면접자 분들은 나에게 어떤 질문을 줄까요?"
        $0.textColor = .customGray
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        $0.setMainLayer()
        $0.backgroundColor = .white
    }
    
    private var setTimeLabel = UILabel()
    
    private let questionLabel = Utilities.shared.generateLabel(text: "질문 입력", color: .customGray, font: .sfPro(size: 12, family: .Regular))
    private let dateSelectLabel = Utilities.shared.generateLabel(text: "기간설정", color: .customGray, font: .sfPro(size: 12, family: .Regular))
    private let selectedLabel = Utilities.shared.generateLabel(text: "직무선택", color: .customGray, font: .sfPro(size: 12, family: .Regular))
    
    lazy var dateContainer = UIView().then {
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = true
    }
    
    private let startDateLabel = UILabel().then {
        
        $0.numberOfLines = 0
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "MM/dd(E) HH:mm"
        
        let dates = df.string(from: Date()).components(separatedBy: " ")
        
        let mutable = NSMutableAttributedString(string: dates[1], attributes: [
            NSMutableAttributedString.Key.foregroundColor: UIColor.gray,
            NSMutableAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Bold)
        ])
        
        mutable.append(NSMutableAttributedString(string: "\n \(dates[0])", attributes:[
            NSMutableAttributedString.Key.foregroundColor: UIColor.gray,
            NSMutableAttributedString.Key.font: UIFont.sfPro(size: 12, family: .Regular)]))
        $0.attributedText = mutable
    }
    
    private var endDateLabel = UILabel().then {
        
        $0.numberOfLines = 0
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "MM/dd(E) HH:mm"
        
        let dates = df.string(from: Date().adding(minutes: 60 * 24)).components(separatedBy: " ")
        

        let mutable = NSMutableAttributedString(string: dates[1], attributes: [
            NSMutableAttributedString.Key.foregroundColor: UIColor.gray,
            NSMutableAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Bold)
        ])
        
        mutable.append(NSMutableAttributedString(string: "\n \(dates[0])", attributes:[
            NSMutableAttributedString.Key.foregroundColor: UIColor.gray,
            NSMutableAttributedString.Key.font: UIFont.sfPro(size: 12, family: .Regular)]))
        
        $0.attributedText = mutable
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .white
        self.addSubview(subtitleLabel)
        self.addSubview(titleLabel)
        self.addSubview(questionLabel)
        self.addSubview(questionTextView)
        self.addSubview(selectedLabel)
    
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalToSuperview().offset(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
        }
        
        self.addSubview(dateContainer)
        self.dateContainer.addSubview(dateSelectLabel)
        self.dateContainer.addSubview(setTimeLabel)
        self.dateContainer.addSubview(startDateLabel)
        self.dateContainer.addSubview(endDateLabel)
        
        dateContainer.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                print("hello")
        }).disposed(by: disposeBag)
        
        dateContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.height.equalTo(135)
        }
        
        dateSelectLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(subtitleLabel.snp.leading)
        }

        setTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateSelectLabel.snp.leading).offset(5)
            make.top.equalTo(dateSelectLabel.snp.bottom).offset(10)
        }

        startDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(setTimeLabel.snp.leading)
            make.top.equalTo(setTimeLabel.snp.bottom).offset(10)
        }
        
        
        endDateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(startDateLabel)
            make.leading.equalTo(startDateLabel.snp.trailing).offset(30)
        }
        questionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(dateContainer.snp.bottom).offset(39)
        }
        
        let label = UILabel().then {
            $0.text = "‣"
            $0.font = .sfPro(size: 26, family: .Bold)
            $0.textColor = .gray
        }
        dateContainer.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalTo(startDateLabel).offset(-4)
            make.leading.equalTo(startDateLabel.snp.trailing).offset(10)
        }
        
        questionTextView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(100)
        }
        
        selectedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(questionTextView.snp.bottom).offset(39)
        }
        
    }
    
    func bind(date: Observable<Int>){
        date.subscribe(onNext: { [weak self] date in
            self?.endDateLabel.attributedText = self?.getDateAttributeText(minutes: date)
            self?.setTimeLabel.attributedText = self?.getTimeAttributeText(minutes: date)
            self?.setNeedsDisplay()
        }).disposed(by: disposeBag)
        
        questionTextView.rx.didBeginEditing
            .bind { [weak self] _ in
                if self?.questionTextView.text == "면접자 분들은 나에게 어떤 질문을 줄까요?"{
                    self?.questionTextView.text = ""
                    self?.questionTextView.textColor = .black
                }
                
            }.disposed(by: disposeBag)
        
        questionTextView.rx.didEndEditing
            .bind { [weak self] _ in
                if self?.questionTextView.text == nil || self?.questionTextView.text == "" {
                    self?.questionTextView.text = "면접자 분들은 나에게 어떤 질문을 줄까요?"
                    self?.questionTextView.textColor = .customGray
                }
            }.disposed(by: disposeBag)
    }

    private func getTimeAttributeText(minutes: Int) -> NSMutableAttributedString {
        let hour = String(format: "%02d", minutes / 60)
        let minutes = String(format: "%02d", minutes % 60)
        
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
    
    private func getDateAttributeText(minutes: Int) -> NSMutableAttributedString {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "MM/dd(E) HH:mm"
        
        let dates = df.string(from: Date().adding(minutes: minutes)).components(separatedBy: " ")
        
        let mutable = NSMutableAttributedString(string: dates[1], attributes: [
            NSMutableAttributedString.Key.foregroundColor: UIColor.gray,
            NSMutableAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Bold)
        ])
        mutable.append(NSMutableAttributedString(string: "\n \(dates[0])", attributes: [
            NSMutableAttributedString.Key.foregroundColor: UIColor.gray,
            NSMutableAttributedString.Key.font: UIFont.sfPro(size: 12, family: .Regular)
        ]))
        return mutable
    }
}
