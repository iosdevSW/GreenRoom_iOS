//
//  CreatePopOverViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import UIKit

protocol CreatePopOverDeleagte: AnyObject {
    func didTapGreenRoomCreate()
    func didTapQuestionListCreate()
}

final class CreatePopOverViewController: BaseViewController {
    
    weak var delegate: CreatePopOverDeleagte?
    
    private lazy var greenroomButton = UIButton().then {
        $0.backgroundColor = .white
        
        var attText = AttributedString.init("그린룸")
        attText.obliqueness = 0.2 // To set the slant of the text
        attText.font = .sfPro(size: 16, family: .Bold)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(named:"createGreenroom")?.withRenderingMode(.alwaysOriginal)
            config.imagePadding = 10
            config.attributedTitle = attText
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 35)
            $0.configuration = config
        } else {
            $0.setAttributedTitle(NSAttributedString(attText), for: .normal)
            $0.setImage(UIImage(named:"createGreenroom")?.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.imageView?.tintColor = .mainColor
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
    }
    
    private lazy var questionListButton = UIButton().then {
        $0.backgroundColor = .white
        
        var attText = AttributedString.init("질문리스트")
        attText.obliqueness = 0.2 // To set the slant of the text
        attText.font = .sfPro(size: 16, family: .Bold)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(named:"createQuestionList")?.withRenderingMode(.alwaysOriginal)
            config.imagePadding = 10
            config.attributedTitle = attText
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 35)
            $0.configuration = config
        } else {
            $0.setAttributedTitle(NSAttributedString(attText), for: .normal)
            $0.setImage(UIImage(named:"createQuestionList")?.withRenderingMode(.alwaysOriginal), for: .normal)
            $0.imageView?.tintColor = .mainColor
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
    }
    
    override func configureUI() {
        self.view.backgroundColor = .mainColor
        
        self.preferredContentSize = CGSize(width: 160, height: 110)
        
        self.view.addSubview(greenroomButton)
        self.view.addSubview(questionListButton)
        
        greenroomButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(55)
        }
        questionListButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(55)
            
        }
    }
    
    override func setupBinding() {
        greenroomButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { onwer, _ in
                onwer.dismiss(animated: false) {
                    onwer.delegate?.didTapGreenRoomCreate()
                }
            }).disposed(by: disposeBag)
        
        questionListButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { onwer, _ in
                onwer.dismiss(animated: false) {
                    onwer.delegate?.didTapQuestionListCreate()
                }
            }).disposed(by: disposeBag)
        
    }
}
