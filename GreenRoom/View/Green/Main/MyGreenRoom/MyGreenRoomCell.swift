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

final class MyGreenRoomCell: UICollectionViewCell {
    
    static let reuseIdentifer = "MyGreenRoomCell"
    
    //MARK: - Properties
    private var disposeBag = DisposeBag()
    
    weak var delegate: MyGreenRoomCellDelegate?
    
    var question: MyPublicQuestion! {
        didSet { configure() }
    }
    
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
    
    private lazy var questionTextView = UITextView().then {
        $0.backgroundColor = .white
        
        $0.textColor = .black
        $0.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        
        $0.attributedText = NSAttributedString(
            string: "대부분의 프로젝트는 프로세스는 어떠하며 어떤 롤이 었나요?",
            attributes: [
                NSAttributedString.Key.paragraphStyle : style,
                NSAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Regular),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ])
        
        $0.isUserInteractionEnabled = false
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configureUI(){
        self.backgroundColor = .white
        
        let topLine = UIView()
        topLine.backgroundColor = .mainColor
        
        self.contentView.addSubview(topLine)
        topLine.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(2)
        }
        
        self.contentView.addSubview(questionTextView)
        questionTextView.snp.makeConstraints { make in
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
        
        contentView.addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(questionTextView.snp.leading)
            make.height.equalTo(60)
        }
        
        contentView.addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.leading.equalTo(questionTextView.snp.trailing)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(60)
        }
    }
    
    private func configure(){
        
        self.questionTextView.text = question.question
        leftButton.isHidden = !question.hasPrev
        rightButton.isHidden = !question.hasNext
    }
    
    func bind() {
        leftButton.rx.tap.subscribe(onNext: {
            print("prev")
            self.delegate?.didTapNext()
        }).disposed(by: disposeBag)
        
        rightButton.rx.tap.subscribe(onNext: {
            print("next")
            self.delegate?.didTapPrev()
        }).disposed(by: disposeBag)
    }
}
