//
//  DetailRecentQuestionViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/06.
//

import UIKit
import RxSwift

final class DetailRecentQuestionViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        
    }
    
    override func setupAttributes() {
        
    }
    
    override func setupBinding() {
        
    }
}

extension DetailRecentQuestionViewController {
    private func configureCollectionView() {
        let layout = generateLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(DetailRecentHeaderView.self, forSupplementaryViewOfKind: DetailRecentHeaderView.reuseIdentifier, withReuseIdentifier: DetailRecentHeaderView.reuseIdentifier)
//        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: DetailCell)
    }
    
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 {
                return self?.generateFilteringLayout()
            } else {
                return self?.generateQuestionLayout()
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
    
    private func generateQuestionLayout() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalWidth(1/9))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)

        return section
    }
}
