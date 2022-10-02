//
//  KPQuestionsViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit
import RxCocoa

final class KPQuestionsViewController: BaseViewController {
    //MARK: - Properties
    private let viewmodel: KeywordViewModel
    private var isEditingMode = false
    
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
        $0.setTitle("키워드 ON", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 16, family: .Semibold)
        $0.backgroundColor = .mainColor
        $0.isHidden = true
        $0.tag = 0
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private let keywordOffButton = UIButton(type: .system).then{
        $0.setTitle("키워드 OFF", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 16, family: .Semibold)
        $0.backgroundColor = .mainColor
        $0.isHidden = true
        $0.tag = 1
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private let moveGroupButton = UIButton(type: .system).then{
        $0.setTitle("그룹이동", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 16, family: .Semibold)
        $0.backgroundColor = .mainColor
        $0.isHidden = true
        $0.tag = 3
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private let deleteQuestionButton = UIButton(type: .system).then{
        $0.setTitle("키워드 OFF", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 16, family: .Semibold)
        $0.backgroundColor = .mainColor
        $0.isHidden = true
        $0.tag = 4
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.viewmodel.updateGroupQuestions()
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
    
    //MARK: - Selector
    @objc func didClickKeywordButton(_ sender: UIButton) {
        let isKeywordOn = sender.tag == 0 ? true : false
        self.viewmodel.keywordOnOff = isKeywordOn
        self.navigationController?.pushViewController(KPPrepareViewController(viewmodel: viewmodel), animated: true)
    }
    
    @objc func didClickQuestionEditButton(_ sender: UIButton) {
        switch sender.tag {
        case 3:
            let groupVC = KPGroupsViewController(viewModel: BaseQuestionsViewModel())
            self.navigationController?.pushViewController(groupVC, animated: true)
        default:
            print("질문삭제클릭")
            
        }
    }
    
    @objc func didClickPracticeButton(_ sender: UIButton) {
        self.practiceInterviewButton.isHidden = true
        self.keywordOnButton.isHidden = false
        self.keywordOffButton.isHidden = false
    }
    
    @objc func didClickAllSelectButton(_ sender: UIButton) {
        print("didClickSelectAll")
    }
    
    @objc func didClickEditButton(_ sender: UIButton) {
        self.isEditingMode = !self.isEditingMode
        self.questionListTableView.reloadData()
        
        viewmodel.selectedQuestionTemp = []
        
        self.moveGroupButton.isHidden = true
        self.deleteQuestionButton.isHidden = true
        self.keywordOnButton.isHidden = true
        self.keywordOffButton.isHidden = true
        self.practiceInterviewButton.isHidden = true
    }
    
    //MARK: - Bind
    override func setupBinding() {
        viewmodel.groupInfo.asDriver()
            .drive(onNext: { [weak self] groupInfo in
                guard let info = groupInfo else { return }
                self?.categoryLabel.text = info.categoryName
                self?.groupNameLabel.text = info.name
                self?.questionCountingLabel.attributedText = self?.setColorHilightAttribute(text: "질문 \(info.questionCnt)개",
                                                                                      hilightString: "\(info.questionCnt)",
                                                                                      color: .point)
            }).disposed(by: disposeBag)
        
        viewmodel.groupQuestions.bind(to: questionListTableView.rx.items(cellIdentifier: "QuestionListCell", cellType: QuestionListCell.self)) { index, item, cell in
            // init
            cell.selectionStyle = .none
            cell.mainLabel.textColor = .black
            cell.checkBox.backgroundColor = .white
            cell.checkBox.layer.borderWidth = 1
            
            cell.mainLabel.text = item.question
            
            let registerText = item.register == true ? "등록" : "미등록"
            let registerTextColor = item.register == true ? UIColor.point : UIColor.customDarkGray
            cell.questionTypeLabel.text = registerText
            cell.questionTypeLabel.textColor = registerTextColor
            
            if self.isEditingMode {
                cell.chevronButton.isHidden = true
                cell.checkBox.isHidden = false
            } else {
                cell.chevronButton.isHidden = false
                cell.checkBox.isHidden = true
            }
        }.disposed(by: disposeBag)
        
        questionListTableView.rx.itemSelected
            .bind(onNext: { indexPath in // 서비스 로직시엔 Id로 다룰 것 같음
                let cell = self.questionListTableView.cellForRow(at: indexPath) as! QuestionListCell
                if self.isEditingMode {
                    cell.checkBox.backgroundColor = .mainColor
                    cell.checkBox.layer.borderWidth = 0
                } else {
                    cell.mainLabel.textColor = .darken
                }
                
                let title = cell.mainLabel.text!
                self.viewmodel.selectedQuestionTemp.append(title)
            }).disposed(by: disposeBag)
        
        questionListTableView.rx.itemDeselected
            .bind(onNext: { indexPath in // 서비스 로직시엔 Id로 다룰 것 같음
                let cell = self.questionListTableView.cellForRow(at: indexPath) as! QuestionListCell
                if self.isEditingMode {
                    cell.checkBox.backgroundColor = .white
                    cell.checkBox.layer.borderWidth = 1
                } else {
                    cell.mainLabel.textColor = .black
                }
                
                let title = cell.mainLabel.text!
                if let index = self.viewmodel.selectedQuestionTemp.firstIndex(of: title){
                    self.viewmodel.selectedQuestionTemp.remove(at: index)
                }
            }).disposed(by: disposeBag)
            
        viewmodel.selectedQuestionObservable
            .bind(onNext: { titles in // 서비스 로직 호출할땐 응답받는 구조체로 대체 (아직 서비스API 미구현 임시로 string배열로 받음)
                if self.isEditingMode {
                    if titles.count == 0 {
                        self.moveGroupButton.isHidden = true
                        self.deleteQuestionButton.isHidden = true
                    }else {
                        self.moveGroupButton.isHidden = false
                        self.deleteQuestionButton.isHidden = false
                        
                    }
                } else {
                    if titles.count == 0 {
                        self.practiceInterviewButton.isHidden = true
                    }else {
                        self.practiceInterviewButton.setTitle("\(titles.count)개의 면접 연습하기", for: .normal)
                        self.practiceInterviewButton.isHidden = false
                    }
                    self.keywordOnButton.isHidden = true
                    self.keywordOffButton.isHidden = true
                }
               
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
        self.allSelectButton.addTarget(self, action: #selector(self.didClickAllSelectButton(_:)), for: .touchUpInside)
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
        moveGroupButton.addTarget(self, action: #selector(didClickQuestionEditButton(_:)), for: .touchUpInside)
        moveGroupButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(14)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(58)
        }

        self.view.addSubview(deleteQuestionButton)
        deleteQuestionButton.addTarget(self, action: #selector(didClickQuestionEditButton(_:)), for: .touchUpInside)
        deleteQuestionButton.snp.makeConstraints{ make in
            make.leading.equalTo(moveGroupButton.snp.trailing).offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.width.equalTo(moveGroupButton)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.height.equalTo(58)
        }
    }
}
