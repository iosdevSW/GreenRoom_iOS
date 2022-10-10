//
//  MakePublicAnswerViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/04.
//

import UIKit
import RxSwift

final class MakePublicAnswerViewController: BaseViewController {
    
    //MARK: - Properties
    private let viewModel: MakePublicAnswerViewModel
    private var headerView = QuestionHeaderView(frame: .zero)
    private var keywordView: KeywordRegisterView!
    
    private let doneButton = UIButton().then {
        $0.setTitle("확인",for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var answerTextView = UITextView().then {
        $0.isEditable = true
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.sizeToFit()
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
        
        self.keywordView = KeywordRegisterView(viewModel: RegisterKeywordViewModel(id: viewModel.answer.header.id, answerType: .public))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(handleDismissal))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        
        guard let tabbarcontroller = tabBarController as? CustomTabbarController else { return }
        tabbarcontroller.createButton.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tabbarcontroller = tabBarController as? CustomTabbarController else { return }
        tabbarcontroller.createButton.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configureUI() {
        super.configureUI()
        
        let headerHeight = UIScreen.main.bounds.height * 0.3
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        self.view.addSubview(keywordView)
        keywordView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(15)
            make.height.equalTo(115)
        }
        
        self.view.addSubview(answerTextView)
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
                guard let self = self else { return }
                
                if self.answerTextView.text == self.viewModel.placeholder {
                    self.answerTextView.text = nil
                    self.answerTextView.textColor = .black
                }
            }).disposed(by: disposeBag)
        
        answerTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] _ in
                
                guard let self = self else { return }
                if self.answerTextView.text.isEmpty || self.answerTextView.text == nil {
                    self.answerTextView.attributedText = self.viewModel.placeholder.addLineSpacing(foregroundColor: .lightGray)
                }
            }).disposed(by: disposeBag)
        
        let input = MakePublicAnswerViewModel.Input(text: answerTextView.rx.text.orEmpty.asObservable(),
                                                    endEditingTrigger: self.answerTextView.rx.didEndEditing.asObservable(),
                                                    keywords: keywordView.output.registeredKeywords,
                                                    doneButtonTrigger: doneButton.rx.tap.asObservable())
        
        doneButton.rx.tap.subscribe(onNext: {
            self.answerTextView.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.question.subscribe(onNext: { question in
            self.headerView.question = Question(id: question.header.id, question: question.header.question, categoryName: question.header.categoryName, groupCategoryName: "")
        }).disposed(by: disposeBag)
        
        output.successMessage.emit(onNext: { [weak self] message in
            guard let self = self else { return }
            let alert = self.comfirmAlert(title: "등록이 완료되었습니다.", subtitle: message) { _ in
                self.navigationController?.popViewController(animated: false)
            }
            self.present(alert, animated: true)
        }).disposed(by: disposeBag)
        
        output.failMessage.emit(onNext: { [weak self] message in
            guard let self = self else { return }
            let alert = self.comfirmAlert(title: "삭제 실패", subtitle: message) { _ in
                
            }
            self.present(alert, animated: true)
        }).disposed(by: disposeBag)
        
    }
    //MARK: - Selector
    @objc func handleDismissal() {
        self.navigationController?.popViewController(animated: false)
    }
}
