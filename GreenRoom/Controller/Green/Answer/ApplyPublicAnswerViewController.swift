//
//  MakePublicAnswerViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/04.
//

import UIKit
import RxSwift

final class ApplyPublicAnswerViewController: BaseViewController {
    
    //MARK: - Properties
    private let viewModel: MakePublicAnswerViewModel
    private var headerView = AnswerHeaderView(frame: .zero)
    private lazy var keywordView = KeywordRegisterView(
        viewModel: RegisterKeywordViewModel(
            id: viewModel.answer.header.id,
            answerType: .public,
            repository: RegisterKeywordRepository())
    )
    
    private let doneButton = UIButton().then {
        $0.setTitle("확인",for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var answerTextView = UITextView().then {
        $0.isEditable = true
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 2
        $0.isScrollEnabled = true
        $0.attributedText = viewModel.placeholder.addLineSpacing(foregroundColor: .lightGray)
    }
    
    //MARK: - Lifecycle
    init(viewModel: MakePublicAnswerViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        self.configureNavigationBackButtonItem()
        self.navigationController?.navigationBar.tintColor = .white
        self.hideTabbar()
    }
    
    override func configureUI() {
        super.configureUI()
        
        let headerHeight = UIScreen.main.bounds.height * 0.3
        
        self.view.addSubviews([headerView, keywordView, answerTextView])
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        keywordView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(15)
            make.height.equalTo(115)
        }
        
        answerTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(keywordView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - binding
    override func setupBinding() {
        super.setupBinding()
         
        answerTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                if self.answerTextView.text == self.viewModel.placeholder {
                    self.answerTextView.text = nil
                    self.answerTextView.textColor = .black
                }
            }).disposed(by: disposeBag)
        
        answerTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                if self.answerTextView.text.isEmpty || self.answerTextView.text == nil {
                    self.answerTextView.attributedText = self.viewModel.placeholder.addLineSpacing(foregroundColor: .lightGray)
                }
            }).disposed(by: disposeBag)
        
        let text = self.answerTextView.rx.didEndEditing
            .asObservable()
            .withLatestFrom(answerTextView.rx.text.orEmpty.asObservable())
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
        
        let input = MakePublicAnswerViewModel.Input(
            text: text,
            keywords: keywordView.output.registeredKeywords,
            doneButtonTrigger: doneButton.rx.tap.asObservable())
        
        doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { onwer, _ in
                onwer.answerTextView.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.question
            .withUnretained(self)
            .subscribe(onNext: { onwer, question in
                onwer.headerView.question = question.header.getAnswerHeaderQuestion()
            }).disposed(by: disposeBag)
        
        output.successMessage
            .withUnretained(self)
            .emit(onNext: { onwer, message in
                let alert = onwer.comfirmAlert(title: "등록이 완료되었습니다.", subtitle: message) { _ in
                    onwer.navigationController?.popViewController(animated: false)
                }
                onwer.present(alert, animated: true)
            }).disposed(by: disposeBag)
        
        output.failMessage
            .withUnretained(self)
            .emit(onNext: { onwer, message in
                let alert = onwer.comfirmAlert(title: "등록 실패", subtitle: message) { _ in
                    
                }
                onwer.present(alert, animated: true)
            }).disposed(by: disposeBag)
        
    }
}
