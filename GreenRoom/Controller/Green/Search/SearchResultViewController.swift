//
//  SearchResultViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/26.
//

import UIKit
import RxSwift
import RxDataSources

final class SearchResultViewController: BaseViewController {

    //MARK: - Properties
    private var collectionView: UICollectionView!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Configure
    override func configureUI() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        configureCollectionView()
    }
}

//MARK: - CollectionView
extension SearchResultViewController {
    
    //MARK: - SetAttribute
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width-50, height: 300)
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .backgroundGray
        collectionView.register(SearchResultHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchResultHeaderView.reuseIdentifier)
        collectionView.register(SearchResultNotFoundCell.self, forCellWithReuseIdentifier: SearchResultNotFoundCell.reuseIdentifier)
    }
    //MARK: - CollectionViewDataSource
    
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
    
    //MARK: - CollectionViewLoyout
    private func notFountLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

        section.interGroupSpacing = 14
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func searchResultLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25)

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)

//        section.interGroupSpacing = 14
        section.boundarySupplementaryItems = [header]

        return section
    }
}
