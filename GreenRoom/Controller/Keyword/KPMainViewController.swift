//
//  KPGroupViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/01.
//

import UIKit
import RxSwift

class KPMainViewController: BaseViewController {
    //MARK: - Properties
    
    let viewModel: KeywordViewModel
    lazy var groupView = GroupView().then {
        $0.groupCountingLabel.text = "그룹을 추가해주세요 :)"
        $0.addGroupButton.addTarget(self, action: #selector(self.didClickAddGroupButton(_:)), for: .touchUpInside)
    }
    
    //MARK: - Init
    init(viewModel: KeywordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.viewModel.selectedQuestionTemp = [] // 선택된 질문 초기화
    }
    
    //MARK: - Selector
    @objc func didTapScrap(_ sender: UIButton){
        print("didTapScrap")
    }
    
    @objc func didClickAddGroupButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(KPGroupEditViewController(), animated: true)
    }
    
    @objc func didclickFindButton(_ sender: UIButton) {
        let vc = sender.tag == 0 ? KPFindQuestionViewController() : KPQuestionsViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didClickEditButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(KPGroupEditViewController(), animated: true)
    }
    
    //MARK: - Bind
    override func setupBinding() {
        //그룹뷰 테이블 뷰 바인딩
        viewModel.groupsObservable
            .bind(to: groupView.groupTableView.rx.items(cellIdentifier: "GroupCell", cellType: GroupCell.self)) { index, item, cell in
                cell.groupNameLabel.text = item.name
                cell.categoryLabel.text = item.categoryName
                cell.questionCountingLabel.text = "질문 \(item.questionCnt)개"
                cell.selectionStyle = .none
                cell.editButton.addTarget(self, action: #selector(self.didClickEditButton(_:)), for: .touchUpInside)
            }.disposed(by: disposeBag)
        //그룹 데이터 한번 더 구독하여 nil일 경우 등록된 글 없음처리해주기.
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        let keywordLabel = UILabel().then {
            $0.text = "키워드연습."
            $0.textColor = .mainColor
            $0.font = .sfPro(size: 20, family: .Bold)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(38)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(26)
            }
        }
        
        let findQuestionButton = ChevronButton(type: .system).then {
            $0.setConfigure(title: "면접 질문 찾기",
                            bgColor: .mainColor,
                            radius: 15)
            $0.tag = 0
            self.view.addSubview($0)
            $0.addTarget(self, action: #selector(didclickFindButton(_:)), for: .touchUpInside)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(38)
                make.trailing.equalToSuperview().offset(-38)
                make.top.equalTo(keywordLabel.snp.bottom).offset(33)
                make.height.equalTo(55)
            }
        }
        
        let participatedQuestionsButton = ChevronButton(type: .system).then {
            $0.setConfigure(title: "참여한 질문",
                            bgColor: .sub,
                            radius: 15)
            $0.tag = 1
            self.view.addSubview($0)
            $0.addTarget(self, action: #selector(didclickFindButton(_:)), for: .touchUpInside)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(38)
                make.trailing.equalToSuperview().offset(-38)
                make.top.equalTo(findQuestionButton.snp.bottom).offset(12)
                make.height.equalTo(55)
            }
        }
        
        self.view.addSubview(self.groupView)
        self.groupView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(participatedQuestionsButton.snp.bottom).offset(40)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .mainColor
        self.navigationItem.backButtonTitle = ""
        
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        iconView.image = UIImage(named: "GreenRoomIcon")?.withRenderingMode(.alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconView)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "bookmark"),
                style: .plain,
                target: self,
                action: #selector(self.didTapScrap(_:)))
        ]
        
        navigationController?.navigationBar.tintColor = .mainColor
    }
}
