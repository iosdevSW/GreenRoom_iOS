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
final class GRSearchViewController: BaseViewController {
    
    private var searchBar: UISearchBar!
    private var collectionView: UICollectionView!
    
    var viewModel: GreenRoomViewModel
    
    //MARK: - LifeCycle
    init(viewModel: GreenRoomViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func configureUI(){
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func setupAttributes() {
        configureCollectionView()
        configureSearchBar()
    }
    
    override func setupBinding() {
        Observable.combineLatest(viewModel.recentKeywords.asObserver(), viewModel.popularKeywords.asObserver())
            .map { $0.0 + $0.1 }
            .bind(to: collectionView.rx.items(dataSource: self.dataSource()))
            .disposed(by: disposeBag)
            
    }

}
//MARK: - SetAttributes
extension GRSearchViewController {
    
    private func configureCollectionView(){
        
        let layout = generateLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = .white
        self.collectionView.register(SearchWordCell.self, forCellWithReuseIdentifier: SearchWordCell.reuseIdentifier)
        self.collectionView.register(SearchWordHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchWordHeaderView.reuseIdentifier)
        
    }
    
    private func configureSearchBar(){
        self.navigationController?.navigationBar.tintColor = .customGray
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width - 100, height: 0))
        searchBar.backgroundColor = .white
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchBar.placeholder = "키워드로 검색해보세요!"
        searchBar.layer.borderColor = UIColor.mainColor.cgColor
        searchBar.layer.borderWidth = 2
        searchBar.layer.cornerRadius = 10
        
        searchBar.searchTextField.leftView?.tintColor = .customGray
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = UIColor.white
            
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray!])
            
            textfield.textColor = UIColor.customGray
            textfield.layer.borderColor = UIColor.white.cgColor
            textfield.tintColor = .customGray
            textfield.font = .sfPro(size: 17, family: .Regular)
            textfield.delegate = self
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction(handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
}

//MARK: - UITextFieldDelegate
extension GRSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        CoreDataManager.shared.saveRecentSearch(keyword: text, date: Date()) { completed in
            print(completed)
        }
        return true
    }
}

//MARK: - CollectionViewDataSource
extension GRSearchViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<GRSearchModel> {
        return RxCollectionViewSectionedReloadDataSource<GRSearchModel> {
            dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchWordCell.reuseIdentifier, for: indexPath) as? SearchWordCell else { return UICollectionViewCell() }
            cell.tagType = item
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchWordHeaderView.reuseIdentifier, for: indexPath) as? SearchWordHeaderView else { return UICollectionReusableView() }
            
            switch dataSource[indexPath.section] {
            case .popular(header: let title, items: _):
                headerView.titleText = title
            case .recent(header: let title, items: _):
                headerView.titleText = title
            }
            
            return headerView
            
        }
    }
}

//MARK: - CollectionViewLayout
extension GRSearchViewController {
    func generateLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            
            
            return sectionIndex == 0 ? self.recentLayout() : self.popularLayout()
        }
        return layout
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
        
        return section
    }
    
    private func popularLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: 5, top: 5, trailing: 5, bottom: 5)
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
        
        return section
    }
}
