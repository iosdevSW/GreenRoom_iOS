//
//  MyGreenRoomCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/05.
//

import UIKit
import RxSwift

protocol MyGreenRoomCellDelegate: AnyObject {
    func didTapNext()
    func didTapPrev()
}

final class MyGreenRoomCell: BaseCollectionViewCell {
    
    static let reuseIdentifer = "MyGreenRoomCell"
    
    //MARK: - Properties
    weak var delegate: MyGreenRoomCellDelegate?

    private lazy var leftButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.imageView?.tintColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var rightButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.imageView?.tintColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var questionLabel = PaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)).then {
        $0.backgroundColor = .white
        $0.numberOfLines = 0
    }
    
    private lazy var defaultImageView = UIImageView().then {
        $0.image = UIImage(named: "defaultGreenRoom")
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    //MARK: - Configure
    override func configureUI(){
        
        
        self.contentView.addSubviews([leftButton, rightButton, questionLabel, defaultImageView])
        self.backgroundColor = .white
        
        let topLine = UIView()
        topLine.backgroundColor = .mainColor
        
        self.contentView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(2)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        
        let underLine = UIView()
        underLine.backgroundColor = .mainColor
        self.contentView.addSubview(underLine)
        underLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(2)
        }
        
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(questionLabel.snp.leading)
            make.height.equalTo(60)
        }
        
        rightButton.snp.makeConstraints { make in
            make.leading.equalTo(questionLabel.snp.trailing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(60)
        }
        
        defaultImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    func configure(question: MyGreenRoomQuestion){
        guard let questionText = question.question else {
            return
        }
        defaultImageView.removeFromSuperview()
        self.questionLabel.attributedText = questionText.addLineSpacing(foregroundColor: .black, font: .sfPro(size: 20, family: .Regular))
        leftButton.isHidden = !question.hasPrev
        rightButton.isHidden = !question.hasNext
    }
    
    override func bind() {
        leftButton.rx.tap.subscribe(onNext: {
            self.delegate?.didTapPrev()
        }).disposed(by: disposeBag)
        
        rightButton.rx.tap.subscribe(onNext: {
            self.delegate?.didTapNext()
        }).disposed(by: disposeBag)
    }
}
