//
//  KeywordViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import SwiftKeychainWrapper
import NaverThirdPartyLogin
import RxSwift
import RxCocoa
import KakaoSDKUser

final class KPFindQuestionViewController: BaseViewController{
    //MARK: - Properties
    private let viewModel = BaseQuestionsViewModel()
    
    private let searchBarView = UISearchBar().then{
        $0.placeholder = "키워드로 검색해보세요!"
        $0.searchBarStyle = .minimal
        $0.searchTextField.borderStyle = .none
        $0.searchTextField.textColor = .customGray
        $0.searchTextField.leftView?.tintColor = .customGray
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private lazy var filterView = FilterView(viewModel: CategoryViewModel()).then {
        $0.backgroundColor = .white
    }
    
    private var questionListTableView = UITableView().then{
        $0.backgroundColor = .white
        $0.register(QuestionListCell.self, forCellReuseIdentifier: "QuestionListCell")
        $0.showsVerticalScrollIndicator = true
    }
    
    private let practiceInterviewButton = UIButton(type: .system).then{
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
    
    let btn = UIButton(type: .roundedRect).then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("logout", for: .normal)
    }
    
    //MARK: - Init
    init() {
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

        btn.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
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
    @objc func logout(_ sender: UIButton){
        KeychainWrapper.standard.removeObject(forKey: "accessToken")
        KeychainWrapper.standard.removeObject(forKey: "refreshToken")
        KeychainWrapper.standard.removeObject(forKey: "oauthType")
        LoginService.logout()
            .subscribe(onNext: { isSuccess in
                let oauthType = KeychainWrapper.standard.integer(forKey: "oauthType")!
                switch oauthType {
                case 0:
                    UserApi.shared.logout(){_ in () }
                case 1:
                    NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
                default:
                    print("애플로그아웃")
                }
                
                KeychainWrapper.standard.removeObject(forKey: "accessToken")
                KeychainWrapper.standard.removeObject(forKey: "refreshToken")
                KeychainWrapper.standard.removeObject(forKey: "oauthType")
                
                let loginVC = LoginViewController(loginViewModel: LoginViewModel())
                loginVC.modalPresentationStyle = .fullScreen
                
                self.present(loginVC, animated: false)
            }, onError: { error in
                //로그아웃 실패
                print(error)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Bind
    override func setupBinding() {
        viewModel.baseQuestionsObservable
            .bind(to: questionListTableView.rx.items(cellIdentifier: "QuestionListCell", cellType: QuestionListCell.self)) { index, item, cell in
                cell.mainLabel.text = item.question
                cell.categoryLabel.text = item.categoryName
                cell.questionTypeLabel.text = item.questionType
                cell.isFindMode = true
                
            }.disposed(by: disposeBag)
        
        questionListTableView.rx.modelSelected(ReferenceQuestionModel.self)
            .bind(onNext: { question in
                self.viewModel.selectedQuestionObservable.accept(question)
                self.navigationController?.pushViewController(KPGroupsViewController(viewModel: self.viewModel), animated: true)
            }).disposed(by: disposeBag)
        
        filterView.viewModel.selectedCategoriesObservable
            .subscribe(onNext: { [weak self] ids in
                let idString = ids.map{ String($0)}.joined(separator: ",")
                self?.viewModel.filteringObservable.accept(idString)
                self?.searchBarView.text = nil
            }).disposed(by: disposeBag)
        
        searchBarView.rx.text
            .bind(onNext: { [weak self] text in
                guard let self = self else { return }
                let idString = self.viewModel.filteringObservable.value
                KeywordPracticeService().fetchReferenceQuestions(categoryId: idString, title: text, page: nil)
                    .bind(to: self.viewModel.baseQuestionsObservable)
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - ConfigureUI
    override func configureUI(){
        self.view.addSubview(searchBarView)
        self.searchBarView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalToSuperview().offset(-34)
            make.height.equalTo(36)
        }
        
        self.view.addSubview(self.filterView)
        self.filterView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-42)
            make.top.equalTo(self.searchBarView.snp.bottom).offset(8)
            make.height.equalTo(80)
        }
        
        self.view.addSubview(self.questionListTableView)
        self.questionListTableView.snp.makeConstraints{ make in
            make.top.equalTo(filterView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        self.view.addSubview(btn)
        btn.snp.makeConstraints{ make in
            make.centerY.equalTo(filterView.snp.centerY)
            make.leading.equalTo(filterView.snp.trailing)
        }
    }
}
