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

class KPFindQuestionViewController: BaseViewController{
    //MARK: - Properties
    private let viewModel: KeywordViewModel
    private let categoryViewModel = CategoryViewModel()
    
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
    
    private lazy var filterView = FilterView(viewModel: categoryViewModel)
    
    private var filteringView: FilteringView?
    
    private var blurView: UIVisualEffectView?
    
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
    init(viewModel: KeywordViewModel){
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
        
        bind()
        hideKeyboardWhenTapped()
        setNavigationItem()

        btn.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Method
    func closeFilteringView(){
        self.filteringView?.removeFromSuperview()
        self.blurView?.removeFromSuperview()
        self.filteringView = nil
        self.blurView = nil
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func setNavigationItem() {
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .mainColor
    }
    
    //MARK: - Selector
    @objc func logout(_ sender: UIButton){
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
    
    @objc func didClickFilterButton(_ sender: UIButton) {
        guard filteringView == nil else { return }
        self.tabBarController?.tabBar.isHidden = true
        
        let blurEffect = UIBlurEffect(style: .dark)
    
        self.blurView = UIVisualEffectView(effect: blurEffect).then{
            $0.alpha = 0.3
            $0.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.view.addSubview($0)
        }
        
        filteringView = FilteringView().then{
            self.view.addSubview($0)
            
            $0.selectedCategories = viewModel.filteringList
            $0.cancelButton.addTarget(self, action: #selector(didClickCancelButton(_:)), for: .touchUpInside)
            $0.applyButton.addTarget(self, action: #selector(didClickApplyButton(_:)), for: .touchUpInside)
            
            $0.snp.makeConstraints{ make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.snp.bottom)
                make.height.equalTo(560)
            }
        }
        
        self.categoryViewModel.filteringObservable
            .take(1)
            .subscribe(onNext: { ids in
                guard let filteringView = self.filteringView else { return }
                filteringView.selectedCategories = ids
            }).disposed(by: disposeBag)
    }
    
    @objc func didClickCancelButton(_ sender: UIButton) {
        self.closeFilteringView()
    }
    
    @objc func didClickApplyButton(_ sender: UIButton) {
        guard let filteringView = filteringView else { return }

        self.categoryViewModel.filteringObservable.onNext(filteringView.selectedCategories)
        self.closeFilteringView()
    }
    
    @objc func didClickPracticeButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(KPPrepareViewController(viewmodel: viewModel), animated: true)
    }
    
    //MARK: - Bind
    func bind(){
        _ = viewModel.tabelTemp // 서비스 로직 호출할땐 응답받는 구조체로 대체 (아직 서비스API 미구현 임시로 string배열로 받음)
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
                self.navigationController?.pushViewController(KPGroupsViewController(viewModel: self.viewModel), animated: true)
            })
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
        self.filterView.filterButton.addTarget(self, action: #selector(didClickFilterButton(_:)), for: .touchUpInside)
        self.filterView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(42)
            make.trailing.equalToSuperview().offset(-42)
            make.top.equalTo(self.searchBarView.snp.bottom).offset(20)
            make.height.equalTo(70)
        }
        
        self.view.addSubview(self.questionListTableView)
        self.questionListTableView.snp.makeConstraints{ make in
            make.top.equalTo(filterView.snp.bottom)
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
        
        self.view.addSubview(btn)
        btn.snp.makeConstraints{ make in
            make.centerY.equalTo(filterView.snp.centerY)
            make.leading.equalTo(filterView.snp.trailing)
        }
    }
}
