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

class KPFindQuestionViewController: UIViewController{
    //MARK: - Properties
    let viewModel: KeywordViewModel
    
    let disposeBag = DisposeBag()
    
    let searchBarView = UISearchBar().then{
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
    
    let filterButton = UIButton(type: .roundedRect).then{
        $0.backgroundColor = .mainColor
        $0.setTitle("필터 ", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 12, family: .Semibold)
        $0.setImage(UIImage(named: "filter"), for: .normal)
        $0.tintColor = .white
        $0.semanticContentAttribute = .forceRightToLeft
        $0.layer.cornerRadius = 15
    }
    
    let segmentControl = UISegmentedControl(items: ["기본질문","그린룸 질문"]).then{
        $0.layer.backgroundColor = UIColor.white.cgColor
        $0.selectedSegmentTintColor = UIColor.white
        $0.setBackgroundImage(UIImage(named: "filter"), for: .normal, barMetrics: .default)
        $0.selectedSegmentIndex = 0
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customGray]
        $0.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key : Any], for:.normal)
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainColor]
        $0.setTitleTextAttributes(selectedTitleTextAttributes as [NSAttributedString.Key : Any], for:.selected)
    }
    
    var filteredCategoryView: UICollectionView!
    
    var filteringView: CategoryFilterView?
    
    var blurView: UIVisualEffectView?
    
    var questionListTableView = UITableView().then{
        $0.backgroundColor = .white
        $0.register(QuestionListCell.self, forCellReuseIdentifier: "QuestionListCell")
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
        
        configureUI()
        bind()
        hideKeyboardWhenTapped()
        setNavigationItem()
        
        self.filteredCategoryView.delegate = self
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
        
        filteringView = CategoryFilterView().then{
            self.view.addSubview($0)
            $0.selectedCategories = viewModel.filteringList
            $0.filteringCollectionView.delegate = self
            $0.cancelButton.addTarget(self, action: #selector(didClickCancelButton(_:)), for: .touchUpInside)
            $0.applyButton.addTarget(self, action: #selector(didClickApplyButton(_:)), for: .touchUpInside)
            
            $0.snp.makeConstraints{ make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(self.view.snp.bottom)
                make.height.equalTo(560)
            }
        }
    }
    
    @objc func didClickPracticeButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(KPPrepareViewController(viewmodel: viewModel), animated: true)
    }
    
    @objc func didClickCancelButton(_ sender: UIButton) {
        self.closeFilteringView()
    }
    
    @objc func didClickApplyButton(_ sender: UIButton) {
        self.viewModel.filteringList = self.filteringView!.selectedCategories
        
        self.closeFilteringView()
    }
    
    //MARK: - Bind
    func bind(){
        viewModel.filteringObservable.asObserver()
            .bind(to: filteredCategoryView.rx.items(cellIdentifier: "ItemsCell", cellType: FilterItemsCell.self)) {index, id ,cell in
                guard let category = CategoryID(rawValue: id) else { return }
                let attributedString = NSMutableAttributedString.init(string: category.title)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: category.title.count))
                cell.itemLabel.attributedText = attributedString
            }.disposed(by: disposeBag)
        
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
}

//MARK: - ConfigureUI
extension KPFindQuestionViewController {
    func configureUI(){
        self.view.addSubview(searchBarView)
        self.searchBarView.snp.makeConstraints{ make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalToSuperview().offset(-34)
            make.height.equalTo(36)
        }
        
        self.view.addSubview(filterButton)
        self.filterButton.addTarget(self, action: #selector(didClickFilterButton(_:)), for: .touchUpInside)
        self.filterButton.snp.makeConstraints{ make in
            make.top.equalTo(searchBarView.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(42)
            make.height.equalTo(27)
            make.width.equalTo(63)
        }
        
//        self.view.addSubview(segmentControl)
//        self.segmentControl.snp.makeConstraints{ make in
//            make.centerY.equalTo(filterButton.snp.centerY)
//            make.trailing.equalToSuperview().offset(-48)
//        }
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 16
        }
        
        self.filteredCategoryView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then{
            $0.backgroundColor = .white
            $0.register(FilterItemsCell.self, forCellWithReuseIdentifier: "ItemsCell")
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(filterButton.snp.bottom).offset(12)
                make.leading.equalToSuperview().offset(52)
                make.trailing.equalToSuperview().offset(-52)
                make.height.equalTo(22)
            }
        }
        
        self.view.addSubview(self.questionListTableView)        
        self.questionListTableView.snp.makeConstraints{ make in
            make.top.equalTo(filteredCategoryView.snp.bottom)
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
            make.centerY.equalTo(filterButton.snp.centerY)
            make.leading.equalTo(filterButton.snp.trailing)
        }
        
    }
}

//MARK: - CollectionViewLayoutDelegate
extension KPFindQuestionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var items = [Int]()
        
        if collectionView == self.filteredCategoryView{
            items = viewModel.filteringList
        }else {
            items = filteringView!.selectedCategories
        }
        
        let id = items[indexPath.item]
        let category = CategoryID(rawValue: id)
        
        let tempLabel = UILabel()
        tempLabel.font = .sfPro(size: 12, family: .Regular)
        tempLabel.text = category?.title
        
        return CGSize(width: tempLabel.intrinsicContentSize.width, height: 22)
    }
}
