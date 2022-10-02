//
//  KPGroupViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/01.
//

import UIKit
import RxSwift

final class KPMainViewController: BaseViewController {
    //MARK: - Properties
    private let viewModel: KeywordViewModel
    
    private lazy var groupView = GroupView(viewModel: GroupViewModel())
    
    private let findQuestionButton = ChevronButton(type: .system).then {
        $0.setConfigure(title: "면접 질문 찾기",
                        bgColor: .mainColor,
                        radius: 15)
    }
    
    private let participatedQuestionsButton = ChevronButton(type: .system).then {
        $0.setConfigure(title: "참여한 질문",
                        bgColor: .sub,
                        radius: 15)
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
        self.groupView.viewModel.updateGroupList()
    }
    
    //MARK: - Selector
    @objc func didTapScrap(_ sender: UIButton){
        print("didTapScrap")
    }
    
    //MARK: - Bind
    override func setupBinding() {
        findQuestionButton.rx.tap
            .bind(onNext: { [weak self] _ in
                let vc =  KPFindQuestionViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        participatedQuestionsButton.rx.tap
            .bind(onNext: { [weak self] _ in
                let vc = KPGreenRoomQuestionsViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        let keywordLabel = UILabel().then {
            $0.text = "키워드연습"
            $0.textColor = .mainColor
            $0.font = .sfPro(size: 20, family: .Bold)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(38)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(26)
            }
        }
        
        self.view.addSubview(self.findQuestionButton)
        self.findQuestionButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(38)
            make.trailing.equalToSuperview().offset(-38)
            make.top.equalTo(keywordLabel.snp.bottom).offset(33)
            make.height.equalTo(55)
        }
        
        self.view.addSubview(self.participatedQuestionsButton)
        self.participatedQuestionsButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(38)
            make.trailing.equalToSuperview().offset(-38)
            make.top.equalTo(findQuestionButton.snp.bottom).offset(12)
            make.height.equalTo(55)
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
