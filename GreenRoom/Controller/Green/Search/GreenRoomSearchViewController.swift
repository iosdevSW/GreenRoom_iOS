//
//  GRSearchViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import RxViewController

final class GreenRoomSearchViewController: BaseViewController {
    
    private var searchBar: UISearchBar!
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
    
    private let viewModel: SearchViewModel
    
    //MARK: - LifeCycle
    init(viewModel: SearchViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.hideTabbar()
    }
    
    override func configureUI(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func setupAttributes() {
        super.setupAttributes()
        
        configureCollectionView()
        configureSearchBar()
    }
    
    override func setupBinding() {
        let text = self.searchBar.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(self.searchBar.searchTextField.rx.text.orEmpty.asObservable())
            .distinctUntilChanged()
        
        let input = SearchViewModel.Input(
            trigger: self.rx.viewWillAppear.asObservable(),
            text: text)
        
        let output = self.viewModel.transform(input: input)
        
        self.searchBar.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(self.searchBar.searchTextField.rx.text.orEmpty.asObservable())
            .withUnretained(self)
            .subscribe(onNext: { onwer, keyword in
                let viewModel = FilteringViewModel(
                    mode: .search(keyword: keyword),
                    publicQuestionService: PublicQuestionService()
                )
                let vc = FilteringQuestionViewController(viewModel: viewModel)
                onwer.navigationController?.pushViewController(vc, animated: false)
            }).disposed(by: disposeBag)
        
        self.collectionView.rx.modelSelected(SearchSectionModel.Item.self)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { onwer, keyword in
                let viewModel = FilteringViewModel(
                    mode: .search(keyword: keyword.text),
                    publicQuestionService: PublicQuestionService()
                )
                let vc = FilteringQuestionViewController(viewModel: viewModel)
                onwer.navigationController?.pushViewController(vc, animated: false)
            }).disposed(by: disposeBag)
        
        output.searchedKeyword
            .bind(to: collectionView.rx.items(dataSource: self.dataSource()))
            .disposed(by: disposeBag)
    }
}

//MARK: - SetAttributes
extension GreenRoomSearchViewController {
    
    private func configureCollectionView(){
        self.collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = .white
        self.collectionView.register(SearchWordCell.self, forCellWithReuseIdentifier: SearchWordCell.reuseIdentifier)
        self.collectionView.register(SearchWordHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchWordHeaderView.reuseIdentifier)
    }
    
    private func configureSearchBar(){
        self.navigationController?.navigationBar.tintColor = .customGray
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width - 70, height: 0))
        self.searchBar.backgroundColor = .white
        self.searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        self.searchBar.placeholder = "키워드로 검색해보세요!"
        self.searchBar.layer.borderColor = UIColor.mainColor.cgColor
        self.searchBar.layer.borderWidth = 2
        self.searchBar.layer.cornerRadius = 10
        self.searchBar.searchTextField.leftView?.tintColor = .customGray
        
        guard let textfield = self.searchBar.value(forKey: "searchField") as? UITextField else { return }
        
        textfield.backgroundColor = UIColor.white
        
        textfield.attributedPlaceholder = NSAttributedString(
            string: textfield.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray!])
        
        textfield.textColor = UIColor.black
        textfield.layer.borderColor = UIColor.white.cgColor
        textfield.tintColor = .customGray
        textfield.font = .sfPro(size: 17, family: .Regular)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.searchBar)
        
    }
}

//MARK: - CollectionViewDataSource
extension GreenRoomSearchViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<SearchSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<SearchSectionModel> {
            dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchWordCell.reuseIdentifier, for: indexPath) as? SearchWordCell else { return UICollectionViewCell() }
            cell.tagType = item
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchWordHeaderView.reuseIdentifier, for: indexPath) as? SearchWordHeaderView else { return UICollectionReusableView() }
            
            switch dataSource[indexPath.section] {
            case .popular(header: let title, items: _):
                headerView.configure(with: title)
            case .recent(header: let title, items: _):
                headerView.configure(with: title)
            }
            return headerView
        }
    }
}

//MARK: - CollectionViewLayout
extension GreenRoomSearchViewController {
    func generateLayout() -> UICollectionViewLayout {
        
        return UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                      layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            return sectionIndex == 0 ? self.popularLayout() : self.recentLayout()
        }
    }
    
    private func recentLayout() -> NSCollectionLayoutSection {
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
        
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 0)
        return section
    }
    
    private func popularLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(38)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(14)
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(45))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.interGroupSpacing = 14
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 0)
        return section
    }
}
