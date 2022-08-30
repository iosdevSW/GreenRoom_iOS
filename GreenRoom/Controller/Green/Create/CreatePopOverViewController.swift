//
//  CreatePopOverViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import UIKit

protocol CreatePopOverDeleagte {
    func didTapGreenRoomCreate()
    func didTapQuestionListCreate()
}
final class CreatePopOverViewController: BaseViewController {
    
    var delegate: CreatePopOverDeleagte?
    
    private lazy var greenroomButton = UIButton().then {
        $0.backgroundColor = .white
        $0.tag = 1
        var attText = AttributedString.init("그린룸")
        attText.obliqueness = 0.2 // To set the slant of the text
        attText.font = .sfPro(size: 16, family: .Bold)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(named:"createGreenRoom")
            config.imagePadding = 10
            config.attributedTitle = attText
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 35)
            $0.configuration = config
        } else {
            $0.setAttributedTitle(NSAttributedString(attText), for: .normal)
            $0.setImage(UIImage(named:"createGreenRoom"), for: .normal)
            $0.imageView?.tintColor = .blue
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
        
        $0.addTarget(self, action: #selector(didTapCretaeButton(_:)), for: .touchUpInside)
        
    }
    
    private lazy var questionListButton = UIButton().then {
        $0.backgroundColor = .white
        $0.tag = 2
        var attText = AttributedString.init("질문리스트")
        attText.obliqueness = 0.2 // To set the slant of the text
        attText.font = .sfPro(size: 16, family: .Bold)
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(named:"createQuestionList")
            config.imagePadding = 10
            config.attributedTitle = attText
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 35)
            $0.configuration = config
        } else {
            $0.setAttributedTitle(NSAttributedString(attText), for: .normal)
            $0.setImage(UIImage(named:"createQuestionList"), for: .normal)
            $0.imageView?.tintColor = .blue
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
        $0.addTarget(self, action: #selector(didTapCretaeButton(_:)), for: .touchUpInside)
    }

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
          
    override func configureUI() {
        self.view.backgroundColor = .mainColor

        self.preferredContentSize = CGSize(width: 170, height: 110)
        
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
    
    //MARK: - Selector
    @objc func didTapCretaeButton(_ sender: UIButton){
        dismiss(animated: false) {
            print(sender.tag)
            if sender.tag == 1 {
                self.delegate?.didTapGreenRoomCreate()
            } else {
                self.delegate?.didTapQuestionListCreate()
            }   
        }
    }
}
