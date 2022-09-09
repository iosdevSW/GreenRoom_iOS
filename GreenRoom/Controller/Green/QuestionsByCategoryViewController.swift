//
//  QuestionsByCategoryViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/08.
//

import UIKit
import RxSwift
import RxDataSources

final class QuestionsByCategoryViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    var viewModel: GreenRoomViewModel!
    
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
        navigationController?.navigationBar.backgroundColor = .clear
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
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func setupAttributes() {
        configureCollectionView()
    }
    
    override func setupBinding() {
//        self.viewModel.recent.bind(to: collectionView.rx.items(dataSource: self.dataSource())).disposed(by: disposeBag)
    }
}

//MARK: - CollectionView
extension QuestionsByCategoryViewController {
    
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width * 0.9, height: view.bounds.height/4)
        layout.headerReferenceSize = CGSize(width: view.bounds.width , height: view.bounds.height * 0.14)
        layout.minimumLineSpacing = view.bounds.size.height * 0.03
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backgroundGary
        collectionView.register(InfoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderView.reuseIdentifier)
        collectionView.register(QuestionByCategoryCell.self, forCellWithReuseIdentifier: QuestionByCategoryCell.reuseIdentifier)
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
            (dataSource, collectionView, indexPath, item) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionByCategoryCell.reuseIdentifier, for: indexPath) as? QuestionByCategoryCell else { return UICollectionViewCell() }

            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind,
            indexPath in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderView.reuseIdentifier, for: indexPath) as? InfoHeaderView else {
                
                    return UICollectionReusableView()
                
            }
        
            header.filterHidden = true
            header.info = Info(title: "디자인", subTitle: "관련된 질문리스트를 보여드려요!\n\n질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)")
            return header
        }
    }
}
