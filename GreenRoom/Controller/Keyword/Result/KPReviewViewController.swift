//
//  KPReviewViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/31.
//

import UIKit
import AVFoundation.AVPlayer
import RxDataSources

class KPReviewViewController: BaseViewController, UICollectionViewDelegate {
    //MARK: - Properties
    private var collectionView: UICollectionView!
    private let viewModel: KeywordViewModel
    
    //MARK: - Init
    init(viewModel: KeywordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.setNavigationBarAppearance()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubviews")
            }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Configure
    override func configureUI() {
        self.collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: generateLayout()).then {
            $0.backgroundColor = .white
            $0.register(ReviewCell.self, forCellWithReuseIdentifier: "ReviewCell")
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.size.equalToSuperview()
            }
        }
    }
    
    override func setupBinding() {
        viewModel.selectedQuestionDetailModel
            .bind(to: collectionView.rx.items(dataSource: configureDataSource()))
            .disposed(by: disposeBag)
    }
    
    //MARK: - Method
    func setNavigationBarAppearance(){
        if #available(iOS 15,*) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.darken!]
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance
        }
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darken!]
        self.navigationItem.title = self.viewModel.recordingType == .camera ? "녹화 다시보기" : "녹음 다시듣기"
    }
}


//MARK: - ConfigureDataSource
extension KPReviewViewController {
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<KPDetailModel> {
        return RxCollectionViewSectionedReloadDataSource<KPDetailModel> { dataSource, collectionView, indexPath, item  in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
//            cell.keywordIsOn = self.viewmodel.keywordOnOff
            //키워드 on일 경우
            if self.viewModel.keywordOnOff.value {
                let persent = item.persent ?? 0
                cell.keywordPersent.text = String(format: "%2.f%%", persent * 100)
                
//                cell.keywordLabel.text = item.keyword.joined(separator: "  ")
            }
            
            cell.questionLabel.text = "Q\(indexPath.row+1)\n\(item.question)"
            cell.categoryLabel.text = item.categoryName
    
            let url = self.viewModel.URLs.value[indexPath.row]
            cell.recordingType = self.viewModel.recordingType
            cell.url = url
        
            return cell
        }
    }
}

//CollectionView Layout
extension KPReviewViewController {
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{(sectionIndex: Int,
                                                         layoutEnvironment: NSCollectionLayoutEnvironment)-> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                heightDimension: .estimated(self.view.frame.height)))
            
            let groupSize = NSCollectionLayoutSize.init(widthDimension: .absolute(self.view.frame.width), heightDimension: .estimated(1))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
        
        return layout
    }
}
