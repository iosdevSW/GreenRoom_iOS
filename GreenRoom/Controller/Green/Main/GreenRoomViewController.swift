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
import RxViewController

class GreenRoomViewController: BaseViewController {
    
    //MARK: - Properties
    let viewModel = GreenRoomViewModel()
    private var collectionView: UICollectionView!
    
    private let greenRoomButton = UIButton().then {
        $0.setTitle("그린룸", for: .normal)
        $0.setTitleColor(.mainColor, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.backgroundColor = .clear
    }
    
    private let questionListButton = UIButton().then {
        $0.setTitle("질문리스트", for: .normal)
        $0.setTitleColor(.customGray, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.backgroundColor = .clear
    }
    private let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.backgroundColor = .clear
    }
    
    private let bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
        $0.imageView?.contentMode = .scaleAspectFill
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.backgroundColor = .clear
    }
    
    private let underline = UIView().then {
        $0.backgroundColor = .mainColor
        $0.setGradient()
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK: - setup/configure
    override func setupAttributes() {
        self.configureNavigationBar()
        self.configureCollecitonView()
    }
    
    override func setupBinding() {

        let dataSource = self.dataSource()
        
        let input = GreenRoomViewModel.Input(greenroomTap: self.greenRoomButton.rx.tap.asObservable(),
                                             myListTap: self.questionListButton.rx.tap.asObservable(),
                                             trigger: self.rx.viewWillAppear.asObservable())
        
        let output = self.viewModel.transform(input: input)
        
        output.greenroom.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(GreenRoomSectionModel.Item.self).subscribe(onNext: { [weak self] item in
            
            guard let self = self else { return }
            
            switch item {
            case .filtering(interest: _):
                let vc = FilteringQuestionViewController(viewModel: FilteringViewModel(publicQuestionService: PublicQuestionService()))
                self.navigationController?.pushViewController(vc, animated: true)
            case .popular(question: let question):
                let vc = PublicAnswerViewController(viewModel: PublicAnswerViewModel(id: question.id, scrapService: ScrapService(), publicQuestionService: PublicQuestionService()))
                self.navigationController?.pushViewController(vc, animated: true)
            case .recent(question: let question):
                let vc = PublicAnswerViewController(viewModel: PublicAnswerViewModel(id: question.id, scrapService: ScrapService(), publicQuestionService: PublicQuestionService()))
                self.navigationController?.pushViewController(vc, animated: true)
            case .MyGreenRoom(question: let question):
                let vc = PublicAnswerViewController(viewModel: PublicAnswerViewModel(id: question.id!,scrapService: ScrapService(), publicQuestionService: PublicQuestionService()))
                self.navigationController?.pushViewController(vc, animated: true)
            case .MyQuestionList(question: let question):
                let vc = UINavigationController(rootViewController: PrivateAnswerViewController(viewModel: PrivateAnswerViewModel(id: question.id)))
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }).disposed(by: disposeBag)
        
        Observable.merge(greenRoomButton.rx.tap.map { 0 }, questionListButton.rx.tap.map { 1 })
            .subscribe(onNext: { tag in
                
                let questionColor: UIColor = tag == 0 ? .customGray : .mainColor
                let greenRoomColor: UIColor = tag == 0 ? .mainColor : .customGray
                
                self.questionListButton.setTitleColor(questionColor, for: .normal)
                self.greenRoomButton.setTitleColor(greenRoomColor, for: .normal)
                self.disposeBag = DisposeBag()
                self.setupBinding()
                
                let layout = tag == 0 ? self.greenRoomLayout() : self.myListLayout()
                self.collectionView.setCollectionViewLayout(layout, animated: true)
                self.collectionView.layoutSubviews()
                
            }).disposed(by: disposeBag)
        
        searchButton.rx.tap.subscribe(onNext: {
            let vc = GRSearchViewController(viewModel: SearchViewModel())
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        bookmarkButton.rx.tap.subscribe(onNext: {
            let vc = ScrapedQuestionViewController(viewModel: ScrapViewModel())
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        iconView.image = UIImage(named: "GreenRoomIcon")?.withRenderingMode(.alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconView)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: bookmarkButton),
            UIBarButtonItem(customView: searchButton)
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
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(underline.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
    }
    
    
}

//MARK: - collectionView
extension GreenRoomViewController {
    private func configureCollecitonView(){
        let layout = self.greenRoomLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(GRFilteringCell.self, forCellWithReuseIdentifier: GRFilteringCell.reuseIdentifier)
        collectionView.register(GRFilteringHeaderView.self, forSupplementaryViewOfKind: GRFilteringHeaderView.reuseIdentifier, withReuseIdentifier: GRFilteringHeaderView.reuseIdentifier)
        
        collectionView.register(PopularQuestionCell.self, forCellWithReuseIdentifier: PopularQuestionCell.reuseIdentifer)
        collectionView.register(PopularHeader.self, forSupplementaryViewOfKind: PopularHeader.reuseIdentifier, withReuseIdentifier: PopularHeader.reuseIdentifier)
        
        collectionView.register(RecentQuestionCell.self, forCellWithReuseIdentifier: RecentQuestionCell.reuseIdentifer)
        collectionView.register(RecentHeader.self,forSupplementaryViewOfKind: RecentHeader.reuseIdentifier, withReuseIdentifier: RecentHeader.reuseIdentifier)
        collectionView.register(RecentPageFooterView.self, forSupplementaryViewOfKind: RecentPageFooterView.reuseIdentifier, withReuseIdentifier: RecentPageFooterView.reuseIdentifier)
        
        collectionView.register(MyGreenRoomCell.self, forCellWithReuseIdentifier: MyGreenRoomCell.reuseIdentifer)
        collectionView.register(MyGreenRoomHeader.self, forSupplementaryViewOfKind: MyGreenRoomHeader.reuseIdentifier, withReuseIdentifier: MyGreenRoomHeader.reuseIdentifier)
        collectionView.register(MyGreenRoomFooterView.self, forSupplementaryViewOfKind: MyGreenRoomFooterView.reuseIdentifier, withReuseIdentifier: MyGreenRoomFooterView.reuseIdentifier)
        
        collectionView.register(GreenRoomCommonHeaderView.self, forSupplementaryViewOfKind: GreenRoomCommonHeaderView.reuseIdentifier, withReuseIdentifier: GreenRoomCommonHeaderView.reuseIdentifier)
        collectionView.register(MyQuestionListCell.self, forCellWithReuseIdentifier: MyQuestionListCell.reuseIedentifier)
        
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
            (dataSource, collectionView, indexPath, item) in
            
            switch item {
            case .filtering(interest: let category):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GRFilteringCell.reuseIdentifier, for: indexPath) as? GRFilteringCell else { return UICollectionViewCell() }
                cell.category = category
                return cell
                
            case .popular(question: let question):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularQuestionCell.reuseIdentifer, for: indexPath) as? PopularQuestionCell else { return UICollectionViewCell() }
                cell.question = question
                return cell
                
            case .recent(question: let question):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentQuestionCell.reuseIdentifer, for: indexPath) as? RecentQuestionCell else { return UICollectionViewCell() }
                cell.question = question
                return cell
            case .MyGreenRoom(question: let question):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyGreenRoomCell.reuseIdentifer, for: indexPath) as? MyGreenRoomCell else { return UICollectionViewCell() }
                cell.question = question
                cell.delegate = self
                return cell
            case .MyQuestionList(question: let question):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyQuestionListCell.reuseIedentifier, for: indexPath) as? MyQuestionListCell else { return UICollectionViewCell() }
                cell.question = question
                cell.viewModel = self.viewModel
                return cell
            }
        } configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            
            guard let self = self else { return UICollectionReusableView() }
            
            switch kind {
            case GRFilteringHeaderView.reuseIdentifier:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: GRFilteringHeaderView.reuseIdentifier, withReuseIdentifier: GRFilteringHeaderView.reuseIdentifier, for: indexPath) as? GRFilteringHeaderView else { return UICollectionReusableView() }
                return headerView
                
            case PopularHeader.reuseIdentifier:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: PopularHeader.reuseIdentifier, withReuseIdentifier: PopularHeader.reuseIdentifier, for: indexPath) as? PopularHeader else { return UICollectionReusableView() }
                return headerView
                
            case RecentHeader.reuseIdentifier:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: RecentHeader.reuseIdentifier, withReuseIdentifier: RecentHeader.reuseIdentifier, for: indexPath) as? RecentHeader else { return UICollectionReusableView() }
                headerView.delegate = self
                return headerView
                
            case RecentPageFooterView.reuseIdentifier:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: RecentPageFooterView.reuseIdentifier, withReuseIdentifier: RecentPageFooterView.reuseIdentifier, for: indexPath) as? RecentPageFooterView else { return UICollectionReusableView() }
                footerView.bind(input: self.viewModel.currentBannerPage,pageNumber: 3)
                return footerView
                
            case MyGreenRoomHeader.reuseIdentifier:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: MyGreenRoomHeader.reuseIdentifier, withReuseIdentifier: MyGreenRoomHeader.reuseIdentifier, for: indexPath) as? MyGreenRoomHeader else { return UICollectionReusableView() }
                return headerView
                
            case MyGreenRoomFooterView.reuseIdentifier:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: MyGreenRoomFooterView.reuseIdentifier, withReuseIdentifier: MyGreenRoomFooterView.reuseIdentifier, for: indexPath) as? MyGreenRoomFooterView else { return UICollectionReusableView() }
                return footerView
            case GreenRoomCommonHeaderView.reuseIdentifier:
                guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: GreenRoomCommonHeaderView.reuseIdentifier, withReuseIdentifier: GreenRoomCommonHeaderView.reuseIdentifier, for: indexPath) as? GreenRoomCommonHeaderView else { return UICollectionReusableView()}
                header.title = "마이 질문 리스트"
                return header
            default:
                return UICollectionReusableView()
            }
        }
    }
    
    //MARK: - MyListLayout
    private func myListLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0: return self?.generateMyGreenRoomLayout()
            default: return self?.generateMyQuestionListLayout()
            }
        }
    }
    
    private func generateMyQuestionListLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        )
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.09))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: GreenRoomCommonHeaderView.reuseIdentifier, alignment: .topLeading)
        
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    //MARK: - GreenRoomLayout
    private func greenRoomLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            switch sectionIndex {
            case 0: return self?.generateFilteringLayout()
            case 1: return self?.generatePopularQuestionLayout()
            case 2: return self?.generateRecentQuestionLayout()
            default: return self?.generateMyGreenRoomLayout()
            }
        }
    }
    
    private func generateFilteringLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(3.0),
            heightDimension: .absolute(38)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(14)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: GRFilteringHeaderView.reuseIdentifier, alignment: .topLeading)
        
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    private func generatePopularQuestionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
        
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
            elementKind: RecentPageFooterView.reuseIdentifier,
            alignment: .bottom
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader,sectionFooter]
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            
            let bannerIndex = Int(max(0, round(contentOffset.x / environment.container.contentSize.width)))

            self?.viewModel.currentBannerPage.onNext(bannerIndex)
        }
        
        return section
    }
    
    private func generateRecentQuestionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalHeight(0.24))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 8,
            bottom: 5,
            trailing: 8)
        
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 20, trailing: 0)
        return section
        
    }
    
    func generateMyGreenRoomLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                        NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                               heightDimension: .fractionalHeight(0.2)), subitems: [item])
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(60)),
            elementKind: MyGreenRoomHeader.reuseIdentifier,
            alignment: .top)
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)),
            elementKind: MyGreenRoomFooterView.reuseIdentifier,
            alignment: .bottom)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader,sectionFooter]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
        
    }
}

//MARK: - RecentHeaderDelegate
extension GreenRoomViewController: RecentHeaderDelegate {
    func didTapViewAllQeustionsButton() {
        let vc = RecentPublicQuestionsViewController(viewModel: RecentPublicQuestionsViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GreenRoomViewController: MyGreenRoomCellDelegate {
    func didTapNext() {
    }
    
    func didTapPrev() {
    }
}
