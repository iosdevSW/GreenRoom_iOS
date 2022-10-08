//
//  KPGroupsViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit

final class KPGroupsViewController: BaseViewController {
    //MARK: - Properties
    private var baseQuestionViewModel: BaseQuestionsViewModel?
    private var keywordViewModel: KeywordViewModel?
    
    let groupView = GroupView(viewModel: GroupViewModel()).then {
        $0.backgroundColor = .white
    }
    
    //MARK: - Init
    init(viewModel: BaseQuestionsViewModel) {
        self.baseQuestionViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    init(viewModel: KeywordViewModel) {
        self.keywordViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupView.viewModel.updateGroupList()
    }
    
    //MARK: Selector
    
    //MARK: - Bind
    override func setupBinding() {
        if baseQuestionViewModel != nil {
            groupView.groupTableView.rx.modelSelected(GroupModel.self).asDriver()
                .map { $0.id }
                .drive(onNext: { [weak self] groupId in
                    guard let question = self?.baseQuestionViewModel?.selectedQuestionObservable.value else { return }
                    KeywordPracticeService().addInterViewQuestion(groupId: groupId,
                                                                  questionId: question.id,
                                                                  questionTypeCode: question.questionTypeCode)
                    self?.navigationController?.popViewController(animated: true)
                }).disposed(by: disposeBag)
        }
        
        if keywordViewModel != nil {
            groupView.groupTableView.rx.modelSelected(GroupModel.self).asDriver()
                .map { $0.id }
                .drive(onNext: { [weak self] groupId in
                    guard let questions = self?.keywordViewModel?.selectedQuestions.value else { return }
                    let ids = questions.map { $0.id }
                    KeywordPracticeService().moveGroup(groupId: groupId,
                                                       questionIds: ids,
                                                       completion: { _ in
                        self?.keywordViewModel?.updateGroupQuestions()
                        self?.keywordViewModel?.groupEditMode.accept(false)
                        self?.navigationController?.popViewController(animated: true)
                    })
                }).disposed(by: disposeBag)
        }
        
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        self.view.addSubview(self.groupView)
        self.groupView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
