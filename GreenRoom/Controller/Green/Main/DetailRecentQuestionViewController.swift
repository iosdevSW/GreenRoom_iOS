//
//  DetailRecentQuestionViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class DetailRecentQuestionViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel: GRDetailViewModel!
    
    init(viewModel: GRDetailViewModel){
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
        
        guard let tabbarcontroller = tabBarController as? CustomTabbarController else { return }
        tabbarcontroller.createButton.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tabbarcontroller = tabBarController as? CustomTabbarController else { return }
        tabbarcontroller.createButton.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func configureUI() {
        self.view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    override func setupAttributes() {
        configureCollectionView()
    }
    
    override func setupBinding() {
        let input = GRDetailViewModel.Input(trigger: rx.viewWillAppear.asObservable())
        let output = self.viewModel.transform(input: input)
        
        output.recent.bind(to: collectionView.rx.items(dataSource: dataSource())).disposed(by: disposeBag)
    }
}

extension DetailRecentQuestionViewController {
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height/8)
        layout.headerReferenceSize = CGSize(width: view.bounds.width , height: view.bounds.height * 0.25)
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InfoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderView.reuseIdentifier)
        collectionView.register(DetailQuestionListCell.self, forCellWithReuseIdentifier: DetailQuestionListCell.reuseIdentifier)
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
            (dataSource, collectionView, indexPath, item) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailQuestionListCell.reuseIdentifier, for: indexPath) as? DetailQuestionListCell else { return UICollectionViewCell() }

            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind,
            indexPath in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderView.reuseIdentifier, for: indexPath) as? InfoHeaderView else {
                    return UICollectionReusableView()
            }
        
            
            header.info = Info(title: "최근 질문", subTitle: "방금 올라온 모든 질문리스트를 보여드려요!\n질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)")
            return header
        }
    }
    
//    private func generateLayout() -> UICollectionViewCompositionalLayout {
//
//        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//            if sectionIndex == 0 {
//                return self?.generateFilteringLayout()
//            } else {
//                return self?.generateQuestionLayout()
//            }
//        }
//    }
//
//    private func generateFilteringLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .estimated(60),
//            heightDimension: .fractionalHeight(1.0)
//        )
//
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(3.0),
//            heightDimension: .absolute(38)
//        )
//
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//
//        group.interItemSpacing = .fixed(14)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 20, trailing: 0)
//
//        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
//
//        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: GRFilteringHeaderView.reuseIdentifier, alignment: .topLeading)
//
//        section.boundarySupplementaryItems = [header]
//
//        return section
//    }
//
//    private func generateQuestionLayout() -> NSCollectionLayoutSection {
//
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .fractionalHeight(1.0))
//
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(0.8),
//            heightDimension: .fractionalWidth(1/9))
//
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(10)
//
//        let section = NSCollectionLayoutSection(group: group)
//
//        return section
//    }
}
