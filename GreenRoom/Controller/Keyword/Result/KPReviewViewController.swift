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
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.darken!]
        self.navigationItem.title = self.viewModel.recordingType == .camera ? "녹화 다시보기" : "녹음 다시듣기"
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
        viewModel.selectedQ
            .bind(to: collectionView.rx.items(dataSource: configureDataSource()))
            .disposed(by: disposeBag)
    }
}

extension KPReviewViewController {
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<KPDetailModel> {
        return RxCollectionViewSectionedReloadDataSource<KPDetailModel> { dataSource, collectionView, indexPath, item  in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
//            cell.keywordIsOn = self.viewmodel.keywordOnOff
            //키워드 on일 경우
            if self.viewModel.keywordOnOff {
                cell.keywordPersent.text = "75%"
//                cell.keywordLabel.text = "천진난만 현실적 적극적 테스트적 끄적끄적"
            }
            let title = self.viewModel.selectedQuestionTemp[indexPath.row]
            cell.questionLabel.text = "Q\(indexPath.row+1)\n\(title)"
            cell.categoryLabel.text = "공통"
    
            if let url = self.viewModel.videoURLs?[indexPath.row] {
                cell.recordingType = self.viewModel.recordingType
                cell.url = url
            }

        
            return cell
        }
    }
}

//CollectionView Layout
extension KPReviewViewController {
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{(sectionIndex: Int,
                                                         layoutEnvironment: NSCollectionLayoutEnvironment)-> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(self.view.frame.width),
                                                                heightDimension: .absolute(self.view.frame.height)))
            
            let groupSize = NSCollectionLayoutSize.init(widthDimension: .absolute(self.view.frame.width), heightDimension: .absolute(self.view.frame.height))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
        
        return layout
    }
}
