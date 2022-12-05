//
//  DetailPublicAnswerViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/18.
//

import UIKit
import RxSwift

/// 그린룸 질문에 대한 답변을 클릭했을 때 나오는 전체화면 B13-3(1)
final class DetailPublicAnswerViewController: BaseViewController {
    
    private let viewModel: DetailPublicAnswerViewModel
    
    private lazy var output = viewModel.transform(input: DetailPublicAnswerViewModel.Input(trigger: self.rx.viewWillAppear.asObservable()))
    
    private lazy var scrollView = UIScrollView()
    private lazy var headerView = AnswerHeaderView(frame: .zero)
    
    private lazy var profileImageView = ProfileImageView()
    
    private let nameLabel = UILabel().then {
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textColor = .customGray
        $0.text = "박면접"
    }
    
    private lazy var answerLabel = PaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)).then {
        $0.numberOfLines = 0
        $0.textColor = .darkText
        $0.font = .sfPro(size: 16, family: .Regular)
    }
    
    init(viewModel: DetailPublicAnswerViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupAttributes() {
        super.setupAttributes()
    }
    
    override func configureUI() {
        super.configureUI()
        
        let headerHeight = UIScreen.main.bounds.height * 0.3
        
        self.view.addSubviews([headerView, scrollView, profileImageView, nameLabel, answerLabel])
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        scrollView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(self.view.frame.width * 0.1)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        output.answer.subscribe(onNext: { [weak self] answer in
            guard let self = self else { return }
            self.answerLabel.text = answer.answer
            self.nameLabel.text = answer.name
            self.profileImageView.kf.setImage(with: URL(string: answer.profileImage))
        }).disposed(by: disposeBag)
        
        output.header
            .subscribe(onNext: { [weak self] header in
                self?.headerView.question = header
            }).disposed(by: disposeBag)
    }
}
