//
//  KPQuestionsViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit

class KPQuestionsViewController: BaseViewController {
    //MARK: - Properties
    let viewmodel: KeywordViewModel
    
    let categoryLabel = PaddingLabel(padding: .init(top: 0, left: 4, bottom: 0, right: 4)).then {
        $0.text = "공통"
        $0.backgroundColor = .mainColor
        $0.textColor = .white
    }
    
    let groupNameLabel = UILabel().then {
        $0.text = "그룹이름제한10글자"
        $0.textColor = .black
        $0.font = .sfPro(size: 20, family: .Bold)
    }
    
    let allSelectButton = UIButton(type: .system).then {
        $0.setTitle("모두선택", for: .normal)
        $0.setTitleColor(.mainColor, for: .normal)
    }
    
    let questionCountingLabel = UILabel().then {
        $0.text = "질문N개"
        $0.textColor = .black
        $0.font = .sfPro(size: 12, family: .Regular)
    }
    
    let keywordOnButton = UIButton(type: .system).then{
        $0.setTitle("키워드 ON", for: .normal)
        $0.setTitleColor(.mainColor, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 16, family: .Semibold)
        $0.backgroundColor = .white
        $0.tag = 0
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    let keywordOffButton = UIButton(type: .system).then{
        $0.setTitle("키워드 OFF", for: .normal)
        $0.setTitleColor(.customGray, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 16, family: .Semibold)
        $0.backgroundColor = .white
        $0.tag = 1
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    var questionListTableView = UITableView().then{
        $0.backgroundColor = .white
        $0.register(QuestionListCell.self, forCellReuseIdentifier: "QuestionListCell")
        $0.allowsMultipleSelection = true
        $0.showsVerticalScrollIndicator = true
    }
    
    let practiceInterviewButton = UIButton(type: .system).then{
        $0.backgroundColor = .mainColor
        $0.setTitle("n개의 면접 연습하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.isHidden = true
        $0.layer.cornerRadius = 15
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
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Method
    override func setNavigationItem() {
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .mainColor
    }
    
    //MARK: - Selector
    @objc func didClickKeywordButton(_ sender: UIButton) {
        let onButtonColor: UIColor = sender.tag == 0 ? .mainColor : .customGray
        let offButtonColor: UIColor = sender.tag == 0 ? .customGray : .mainColor
        let onButtonBorderWidth: CGFloat = sender.tag == 0 ? 2 : 0
        let offButtonBorderWidth: CGFloat = sender.tag == 0 ? 0 : 2
        let isKeywordOn = sender.tag == 0 ? true : false
            
        self.viewmodel.keywordOnOff = isKeywordOn
        self.keywordOnButton.setTitleColor(onButtonColor, for: .normal)
        self.keywordOnButton.layer.borderWidth = onButtonBorderWidth
        
        self.keywordOffButton.setTitleColor(offButtonColor, for: .normal)
        self.keywordOffButton.layer.borderWidth = offButtonBorderWidth
    }
    
    @objc func didClickPracticeButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(PrepareKeywordPracticeViewController(viewmodel: viewmodel), animated: true)
    }
    
    @objc func didClickAllSelectButton(_ sender: UIButton) {
        print("didClickSelectAll")
    }
    
    //MARK: - Bind
    override func setupBinding() {
        _ = viewmodel.tabelTemp // 서비스 로직 호출할땐 응답받는 구조체로 대체 (아직 서비스API 미구현 임시로 string배열로 받음)
            .bind(to: questionListTableView.rx.items(cellIdentifier: "QuestionListCell", cellType: QuestionListCell.self)) { index, title, cell in
                cell.mainLabel.text = title
                
                let image = UIImage(systemName: "chevron.right")!
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 20))
                imageView.image = image
                imageView.tintColor = .customGray
                cell.accessoryView = imageView
                cell.selectionStyle = .none
            }
        
        _ = questionListTableView.rx.itemSelected
            .bind(onNext: { indexPath in // 서비스 로직시엔 Id로 다룰 것 같음
                let cell = self.questionListTableView.cellForRow(at: indexPath) as! QuestionListCell
                cell.mainLabel.textColor = .darken
                let title = cell.mainLabel.text!
                self.viewmodel.selectedQuestionTemp.append(title)
            })
        
        _ = questionListTableView.rx.itemDeselected
            .bind(onNext: { indexPath in // 서비스 로직시엔 Id로 다룰 것 같음
                let cell = self.questionListTableView.cellForRow(at: indexPath) as! QuestionListCell
                cell.mainLabel.textColor = .black
                let title = cell.mainLabel.text!
                if let index = self.viewmodel.selectedQuestionTemp.firstIndex(of: title){
                    self.viewmodel.selectedQuestionTemp.remove(at: index)
                }
            })
            
        _ = viewmodel.selectedQuestionObservable
            .bind(onNext: { titles in // 서비스 로직 호출할땐 응답받는 구조체로 대체 (아직 서비스API 미구현 임시로 string배열로 받음)
                if titles.count == 0 {
                    self.practiceInterviewButton.isHidden = true
                }else {
                    self.practiceInterviewButton.setTitle("\(titles.count)개의 면접 연습하기", for: .normal)
                    self.practiceInterviewButton.isHidden = false
                }
            })
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
        
//        self.view.addSubview(keywordOnButton)
//        keywordOnButton.addTarget(self, action: #selector(didClickKeywordButton(_:)), for: .touchUpInside)
//        keywordOnButton.snp.makeConstraints{ make in
//            make.leading.equalToSuperview().offset(46)
//            make.top.equalTo(filteredCategoryView.snp.bottom).offset(15)
//            make.height.equalTo(47)
//        }
//
//        self.view.addSubview(keywordOffButton)
//        keywordOffButton.addTarget(self, action: #selector(didClickKeywordButton(_:)), for: .touchUpInside)
//        keywordOffButton.snp.makeConstraints{ make in
//            make.leading.equalTo(keywordOnButton.snp.trailing).offset(42)
//            make.width.equalTo(keywordOnButton.snp.width)
//            make.trailing.equalToSuperview().offset(-46)
//            make.top.equalTo(filteredCategoryView.snp.bottom).offset(15)
//            make.height.equalTo(47)
//        }
        
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
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-35)
            make.height.equalTo(53)
        }
        
    }
}
