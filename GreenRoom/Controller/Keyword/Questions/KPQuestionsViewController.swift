//
//  KPQuestionsViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit
import RxCocoa
import Alamofire

final class KPQuestionsViewController: BaseViewController {
    //MARK: - Properties
    private let viewmodel: KeywordViewModel
    
    private let categoryLabel = PaddingLabel(padding: .init(top: 2, left: 10, bottom: 2, right: 10)).then {
        $0.text = "공통"
        $0.backgroundColor = .mainColor
        $0.textColor = .white
        $0.font = .sfPro(size: 16, family: .Semibold)
    }
    
    private let groupNameLabel = UILabel().then {
        $0.text = "그룹이름제한10글자"
        $0.textColor = .black
        $0.font = .sfPro(size: 20, family: .Bold)
    }
    
    private let allSelectButton = UIButton(type: .system).then {
        $0.setTitle("모두선택", for: .normal)
        $0.setTitleColor(.mainColor, for: .normal)
    }
    
    private let questionCountingLabel = UILabel().then {
        $0.text = "질문N개"
        $0.textColor = .black
        $0.font = .sfPro(size: 12, family: .Regular)
    }
    
    private let keywordOnButton = UIButton(type: .system).then{
        $0.setTitle("  키워드 ON", for: .normal)
        $0.setImage(UIImage(named: "keywordON")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(UIImage(named: "keywordON")?.withTintColor(.mainColor, renderingMode: .alwaysOriginal), for: .disabled)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.tag = 0
        $0.setMainColorButtonConfigure()
    }
    
    private let keywordOffButton = UIButton(type: .system).then{
        $0.setTitle("  키워드 OFF", for: .normal)
        $0.setImage(UIImage(named: "keywordOFF"), for: .normal)
        $0.semanticContentAttribute = .forceLeftToRight
        $0.tag = 1
        $0.setMainColorButtonConfigure()
    }
    
    private let moveGroupButton = UIButton(type: .system).then{
        $0.setTitle("그룹이동", for: .normal)
        $0.tag = 3
        $0.setMainColorButtonConfigure()
    }
    
    private let deleteQuestionButton = UIButton(type: .system).then{
        $0.setTitle("질문삭제", for: .normal)
        $0.tag = 4
        $0.setMainColorButtonConfigure()
    }
    
    private var questionListTableView = UITableView().then{
        $0.backgroundColor = .white
        $0.register(QuestionListCell.self, forCellReuseIdentifier: "QuestionListCell")
        $0.allowsMultipleSelection = true
        $0.showsVerticalScrollIndicator = true
        $0.allowsMultipleSelectionDuringEditing = true
    }
    
    private let practiceInterviewButton = UIButton(type: .system).then{
        $0.backgroundColor = .mainColor
        $0.setTitle("n개의 면접 연습하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.isHidden = true
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor.customGray.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    //MARK: - Init
    init(viewModel: KeywordViewModel){
        self.viewmodel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        hideKeyboardWhenTapped()
        setNavigationItem()
        self.viewmodel.updateGroupQuestions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Method
    override func setNavigationItem() {
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .mainColor
        
        let editButton = UIBarButtonItem(title: "편집",
                                         style: .plain,
                                         target: self,
                                         action: #selector(didClickEditButton(_:)))
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func setColorHilightAttribute(text: String, hilightString: String, color: UIColor) -> NSMutableAttributedString {
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: hilightString))
        
        return attributedStr
    }
    
    func deleteQuestion() {
        guard let groupId = self.viewmodel.selectedGroupID.value else { return }
        let questionIds = self.viewmodel.selectedQuestions.value.map { $0.id }
        
        KPQuestionService().deleteGroupQuestions(groupId: groupId, questionIds: questionIds, completion: { _ in
            self.showGuideAlert(title: "질문이 삭제되었습니다."){ _ in
                self.viewmodel.updateGroupQuestions()
                self.viewmodel.groupEditMode.accept(false)
            }
        })
    }
    
    //MARK: - Selector
    @objc func didClickKeywordButton(_ sender: UIButton) {
        let isKeywordOn = sender.tag == 0 ? true : false
        self.viewmodel.keywordOnOff.accept(isKeywordOn)
        self.navigationController?.pushViewController(KPPrepareViewController(viewmodel: viewmodel), animated: true)
    }
    
    @objc func didClickPracticeButton(_ sender: UIButton) {
        self.practiceInterviewButton.isHidden = true
        self.keywordOnButton.isHidden = false
        self.keywordOffButton.isHidden = false
    }
    
    @objc func didClickEditButton(_ sender: UIButton) {
        self.viewmodel.groupEditMode.accept(!self.viewmodel.groupEditMode.value) 
    }
    
    //MARK: - Bind
    override func setupBinding() {
        viewmodel.groupInfo
            .bind(onNext: { [weak self] groupInfo in
                guard let info = groupInfo else { return }
                self?.categoryLabel.text = info.categoryName
                self?.groupNameLabel.text = info.name
                self?.questionCountingLabel
                    .attributedText = self?.setColorHilightAttribute(text: "질문 \(info.questionCnt)개",
                                                                     hilightString: "\(info.questionCnt)",
                                                                     color: .point)
            }).disposed(by: disposeBag)
        
        viewmodel.groupQuestions
            .bind(to: questionListTableView.rx.items(cellIdentifier: "QuestionListCell", cellType: QuestionListCell.self)) { index, item, cell in
            // init
                if self.viewmodel.selectedQuestions.value.contains(where: { $0.id == item.id}) {
                    cell.isSelected = true
                    self.questionListTableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
                }else {
                    self.questionListTableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
                    cell.isSelected = false
                }
                cell.isEditMode = self.viewmodel.groupEditMode.value
                cell.mainLabel.text = item.question
                cell.tag = item.id
                
                let registerText = item.register == true ? "등록" : "미등록"
                let registerTextColor = item.register == true ? UIColor.point : UIColor.customDarkGray
                cell.questionTypeLabel.text = registerText
                cell.questionTypeLabel.textColor = registerTextColor
                cell.categoryLabel.text = item.categoryName
                
               
            }.disposed(by: disposeBag)
        
        questionListTableView.rx.itemSelected
            .bind(onNext: { indexPath in // 서비스 로직시엔 Id로 다룰 것 같음
                let cell = self.questionListTableView.cellForRow(at: indexPath) as! QuestionListCell
                cell.isSelected = true
            }).disposed(by: disposeBag)
        
        questionListTableView.rx.modelSelected(KPQuestion.self)
            .bind(onNext: { question in
                var questions = self.viewmodel.selectedQuestions.value
                
                questions.append(question)
                self.viewmodel.selectedQuestions.accept(questions)
            }).disposed(by: disposeBag)
        
        questionListTableView.rx.itemDeselected
            .bind(onNext: { indexPath in // 서비스 로직시엔 Id로 다룰 것 같음
                let cell = self.questionListTableView.cellForRow(at: indexPath) as! QuestionListCell
                cell.isSelected = false
            }).disposed(by: disposeBag)
        
        questionListTableView.rx.modelDeselected(KPQuestion.self)
            .bind(onNext: { question in
                let findId = question.id
                var questions = self.viewmodel.selectedQuestions.value
                let ids = questions.map { $0.id }
                if let index = ids.firstIndex(of: findId){
                    questions.remove(at: index)
                    self.viewmodel.selectedQuestions.accept(questions)
                }
            }).disposed(by: disposeBag)
            
        viewmodel.selectedQuestions
            .bind(onNext: { [weak self]questions in
                guard let self = self else { return }
                let isHidden = questions.count == 0 ? true : false
                
                if self.viewmodel.groupEditMode.value {
                    self.moveGroupButton.isHidden = isHidden
                    self.deleteQuestionButton.isHidden = isHidden
                } else {
                    self.practiceInterviewButton.isHidden = isHidden
                    self.practiceInterviewButton.setTitle("\(questions.count)개의 면접 연습하기", for: .normal)
                }
                
                if isHidden {
                    self.allSelectButton.setTitle("모두선택", for: .normal)
                } else {
                    self.allSelectButton.setTitle("모두해제", for: .normal)
                }
                
                self.keywordOnButton.isHidden = true
                self.keywordOffButton.isHidden = true
            }).disposed(by: disposeBag)
        
        viewmodel.selectedQuestions
            .map{ $0.map { $0.register }}
            .bind(onNext: { [weak self] regist in
                if regist.contains(false) {
                    self?.keywordOnButton.isEnabled = false
                    self?.keywordOnButton.setTitleColor(.mainColor, for: .normal)
                    self?.keywordOnButton.backgroundColor = .white
                    
                }else {
                    self?.keywordOnButton.isEnabled = true
                    self?.keywordOnButton.setTitleColor(.white, for: .normal)
                    self?.keywordOnButton.backgroundColor = .mainColor
                    self?.keywordOnButton.tintColor = .white
                }
            }).disposed(by: disposeBag)
        
        self.allSelectButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let vm = self?.viewmodel else { return }
                let count = vm.selectedQuestions.value.count
                
                if count >= 1 { // 질문이 하나 이사이면 모두 해제
                    vm.selectedQuestions.accept([])
                } else { // 하나도 없으면 전체 선택
                    vm.selectedQuestions.accept(vm.groupQuestions.value)
                }
                self?.questionListTableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.viewmodel.groupEditMode
            .bind(onNext: { [weak self]isEditMode in
                if isEditMode {
                    self?.navigationItem.rightBarButtonItem?.title = "취소"
                } else {
                    self?.navigationItem.rightBarButtonItem?.title = "편집"
                }
                
                self?.questionListTableView.reloadData()
                
                self?.viewmodel.selectedQuestions.accept([])
                
                self?.moveGroupButton.isHidden = true
                self?.deleteQuestionButton.isHidden = true
                self?.keywordOnButton.isHidden = true
                self?.keywordOffButton.isHidden = true
                self?.practiceInterviewButton.isHidden = true
            }).disposed(by: disposeBag)
        
        self.moveGroupButton.rx.tap
            .bind(onNext: {
                self.navigationController?.pushViewController(KPGroupsViewController(viewModel: self.viewmodel), animated: true)
            }).disposed(by: disposeBag)
        
        self.deleteQuestionButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let questionCount = self?.viewmodel.selectedQuestions.value.count else { return }
                self?.showAlert(title: "\(questionCount)개의 질문을 삭제하시겠습니까?")
                    .take(1)
                    .subscribe(onNext: { isOk in
                        if isOk {
                            self?.deleteQuestion()
                        }
                    }).disposed(by: self!.disposeBag)
            }).disposed(by: disposeBag)
        
        
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        self.view.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(42)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        self.view.addSubview(self.groupNameLabel)
        self.groupNameLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(42)
            make.top.equalTo(self.categoryLabel.snp.bottom).offset(20)
        }
        
        self.view.addSubview(self.questionCountingLabel)
        self.questionCountingLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(42)
            make.top.equalTo(self.groupNameLabel.snp.bottom).offset(6)
        }
        
        self.view.addSubview(self.allSelectButton)
        self.allSelectButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-38)
            make.centerY.equalTo(self.groupNameLabel.snp.centerY)
        }
        
        self.view.addSubview(self.questionListTableView)
        self.questionListTableView.snp.makeConstraints{ make in
            make.top.equalTo(self.questionCountingLabel.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        self.view.addSubview(self.practiceInterviewButton)
        self.practiceInterviewButton.addTarget(self, action: #selector(self.didClickPracticeButton(_:)), for: .touchUpInside)
        self.practiceInterviewButton.snp.makeConstraints{ make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(58)
        }
        
        self.view.addSubview(keywordOnButton)
        keywordOnButton.addTarget(self, action: #selector(didClickKeywordButton(_:)), for: .touchUpInside)
        keywordOnButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(14)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(58)
        }

        self.view.addSubview(keywordOffButton)
        keywordOffButton.addTarget(self, action: #selector(didClickKeywordButton(_:)), for: .touchUpInside)
        keywordOffButton.snp.makeConstraints{ make in
            make.leading.equalTo(keywordOnButton.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.width.equalTo(keywordOnButton)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(58)
        }
        
        self.view.addSubview(moveGroupButton)
        moveGroupButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(14)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(58)
        }

        self.view.addSubview(deleteQuestionButton)
        deleteQuestionButton.snp.makeConstraints{ make in
            make.leading.equalTo(moveGroupButton.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.width.equalTo(moveGroupButton)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(58)
        }
    }
}
