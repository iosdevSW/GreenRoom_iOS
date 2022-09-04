//
//  GreenRoomViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper
import RxCocoa
import RxDataSources

class GreenRoomViewController: BaseViewController {
    
    //MARK: - Properties
    let viewModel = GreenRoomViewModel()
    private var collectionView: UICollectionView!
    let currentBannerPage = PublishSubject<Int>()
    
    private lazy var greenRoomButton = UIButton().then {
        $0.setTitle("그린룸", for: .normal)
        $0.setTitleColor(.mainColor, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(filterGreenRoom), for: .touchUpInside)
        $0.tag = 0
    }
    
    private lazy var questionListButton = UIButton().then {
        $0.setTitle("질문리스트", for: .normal)
        $0.setTitleColor(.customGray, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(filterGreenRoom), for: .touchUpInside)
        $0.tag = 1
    }
    
    private let underline = UIView().then {
        $0.backgroundColor = .mainColor
        $0.setGradient(
            color1: UIColor(red: 110/255.0, green: 234/255.0, blue: 174/255.0, alpha: 1.0),
            color2: UIColor(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1.0))
    }
    
    private let filterLabel = UILabel().then {
        $0.numberOfLines = 0
        let attributeString = NSMutableAttributedString(string: "빠르게 필터링\n", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Bold)!
        ])
        
        attributeString.append(NSAttributedString(string: "\n관심사 기반으로 맞춤 키워드를 보여드릴게요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGray!,
                                                                                                     NSAttributedString.Key.font: UIFont.sfPro(size: 12, family: .Regular)!]))
        $0.attributedText = attributeString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        KeychainWrapper.standard.remove(forKey: "accessToken")
        //        KeychainWrapper.standard.remove(forKey: "refreshToten")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        configureNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        self.underline.setGradient(
            color1: UIColor(red: 110/255.0, green: 234/255.0, blue: 174/255.0, alpha: 1.0),
            color2: UIColor(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1.0))
        super.viewWillLayoutSubviews()
    }
    
    override func setupBinding() {
        viewModel.isLogin()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { isToken in
                if isToken {
                    print("자동로그인")
                }else {
                    print("로그인필요")
                    let loginVC = LoginViewController(loginViewModel: LoginViewModel())
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: false)
                }
            }).disposed(by: disposeBag)
        
        let dataSource = self.dataSource()
        
        viewModel.greenroom.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        iconView.image = UIImage(named: "GreenRoomIcon")?.withRenderingMode(.alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconView)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "bookmark"),
                style: .plain,
                target: self,
                action: #selector(didTapScrap)),
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .plain,
                target: self,
                action: #selector(didTapSearch))
        ]
        
        navigationController?.navigationBar.tintColor = .mainColor
        
    }
    
    override func configureUI(){
        
        self.view.backgroundColor = .white
        
        let buttonStack = UIStackView(arrangedSubviews: [greenRoomButton,questionListButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
        self.view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(27)
            make.leading.equalToSuperview().offset(view.frame.width / 5)
            make.trailing.equalToSuperview().offset(-view.frame.width / 5)
            make.height.equalTo(30)
        }
        
        self.view.addSubview(underline)
        underline.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(view.frame.width/15)
            make.trailing.equalToSuperview().offset(-view.frame.width/15)
            make.height.equalTo(3)
        }
        
        self.view.addSubview(filterLabel)
        filterLabel.snp.makeConstraints { make in
            make.top.equalTo(underline.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(33)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(filterLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        self.configureNavigationBar()
        self.configureCollecitonView()
    }
    
    @objc func filterGreenRoom(_ sender: UIButton){
        let questionColor: UIColor = sender.tag == 0 ? .customGray : .mainColor
        let greenRoomColor: UIColor = sender.tag == 0 ? .mainColor : .customGray
        
        self.questionListButton.setTitleColor(questionColor, for: .normal)
        self.greenRoomButton.setTitleColor(greenRoomColor, for: .normal)
    }
    
    @objc func didTapSearch(){
        let vc = GRSearchViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapScrap(){
        print("DEBUG Did tap scrap")
    }
}

//MARK: - collectionView
extension GreenRoomViewController {
    private func configureCollecitonView(){
        let layout = self.generateLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .white
        collectionView.register(PopularQuestionCell.self, forCellWithReuseIdentifier: PopularQuestionCell.reuseIdentifer)
        collectionView.register(PopularHeader.self, forSupplementaryViewOfKind: PopularHeader.reuseIdentifier, withReuseIdentifier: PopularHeader.reuseIdentifier)
        
        collectionView.register(RecentQuestionCell.self, forCellWithReuseIdentifier: RecentQuestionCell.reuseIdentifer)
        collectionView.register(RecentHeader.self,forSupplementaryViewOfKind: RecentHeader.reuseIdentifier, withReuseIdentifier: RecentHeader.reuseIdentifier)
        collectionView.register(FooterPageView.self, forSupplementaryViewOfKind: FooterPageView.reuseIdentifier, withReuseIdentifier: FooterPageView.reuseIdentifier)
        
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
            (dataSource, collectionView, indexPath, item) in
            
            switch item {
            case .popular(question: let question):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularQuestionCell.reuseIdentifer, for: indexPath) as? PopularQuestionCell else { return UICollectionViewCell() }
                cell.question = question
                return cell
                
            case .recent(question: let question):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentQuestionCell.reuseIdentifer, for: indexPath) as? RecentQuestionCell else { return UICollectionViewCell() }
                cell.question = question
                return cell
            case .MyGreenRoom(question:_):
                return UICollectionViewCell()
            }
        } configureSupplementaryView: { [weak self] dataSource, collectionView, kind,
            indexPath in
            
            guard let self = self else { return UICollectionReusableView() }
            
            switch kind {
            case PopularHeader.reuseIdentifier:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: PopularHeader.reuseIdentifier, withReuseIdentifier: PopularHeader.reuseIdentifier, for: indexPath) as? PopularHeader else { return UICollectionReusableView() }
                return header
            case RecentHeader.reuseIdentifier:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: RecentHeader.reuseIdentifier, withReuseIdentifier: RecentHeader.reuseIdentifier, for: indexPath) as? RecentHeader else { return UICollectionReusableView() }
                return header
            case FooterPageView.reuseIdentifier:
                guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: FooterPageView.reuseIdentifier, withReuseIdentifier: FooterPageView.reuseIdentifier, for: indexPath) as? FooterPageView else { return UICollectionReusableView() }
                footer.bind(input: self.currentBannerPage,pageNumber: 3)
                return footer
            default:
                return UICollectionReusableView()
            }
        }
    }
    private func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0{
                return self?.generatePopularQuestionLayout()
            } else if sectionIndex == 1{
                return self?.generateRecentQuestionLayout()
            } else {
                return self?.generateRecentQuestionLayout()
            }
            //
            
        }
    }
    private func generatePopularQuestionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)),
            elementKind: PopularHeader.reuseIdentifier,
            alignment: .top)
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)),
            elementKind: FooterPageView.reuseIdentifier,
            alignment: .bottom
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader,sectionFooter]
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in

            let bannerIndex = Int(max(0, round(contentOffset.x /    environment.container.contentSize.width)))
            
            if environment.container.contentSize.height == environment.container.contentSize.width {
                self?.currentBannerPage.onNext(bannerIndex)
            }
        }
        
        return section
    }
    
    private func generateRecentQuestionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.36),
            heightDimension: .fractionalHeight(0.3))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: RecentHeader.reuseIdentifier,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0)
        return section
        
        
        //    func generateMyGRLayout() -> NSCollectionLayoutSection {
        //        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        //
        //        let item = NSCollectionLayoutItem(layoutSize: <#T##NSCollectionLayoutSize#>)
        //    }
    }
    
}

extension GreenRoomViewController {
    @objc func didTap() {
        tabBarController?.selectedIndex = 2
        //        let vc = MyPageViewController(viewModel: MyPageViewModel())
        //        navigationController?.pushViewController(vc, animated: false)
    }
}
