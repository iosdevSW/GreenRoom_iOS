//
//  PracticeDetailViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/30.
//

import UIKit
import RxDataSources
import RxSwift

class KPDetailViewController: BaseViewController {
    //MARK: - Properties
    var collectionView: UICollectionView!
    var indexPath: IndexPath?
    let viewmodel: KeywordViewModel
    
    //MARK: - Init
    init(viewmodel: KeywordViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarColor(.customGray.withAlphaComponent(0.1))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let indexPath = indexPath else {
            return
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setNavigationBarColor(.clear)
    }
    
    //MARK: - Method
    func setNavigationBarColor(_ color: UIColor) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()    // 불투명하게
            appearance.backgroundColor = color
            self.navigationItem.standardAppearance = appearance
            self.navigationItem.scrollEdgeAppearance = appearance    // 동일하게 만들기
        }else {
            self.navigationController?.navigationBar.barTintColor = color
        }
    }
    
    //MARK: - Bind
    override func setupBinding() {
        self.viewmodel.selectedQuestionDetailModel
            .bind(to: self.collectionView.rx.items(dataSource: self.configureDataSource()))
            .disposed(by: self.disposeBag)
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.generateLayout()).then {
            $0.backgroundColor = .white
            $0.bounces = false
            $0.automaticallyAdjustsScrollIndicatorInsets = false
            $0.register(DetailCell.self, forCellWithReuseIdentifier: "DetailCell")
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.trailing.equalToSuperview()
                make.bottom.top.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
    }
}
extension KPDetailViewController {
    private func configureDataSource() -> RxCollectionViewSectionedReloadDataSource<KPDetailModel> {
        return RxCollectionViewSectionedReloadDataSource<KPDetailModel> { dataSource, collectionView, indexPath, item  in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCell
            
            let sttAnswer = item.sttAnswer ?? "변환된 내용 없음"
            
            cell.keywordIsOn = self.viewmodel.keywordOnOff.value
            
            cell.goalProgressBarView.buttonImage = self.viewmodel.recordingType
            
            cell.questionLabel.text = "Q\(indexPath.row+1)\n\(item.question)"
            
            cell.categoryLabel.text = item.categoryName
            
            cell.sttAnswer.text = sttAnswer
            
            cell.answerLabel.text = item.answer
            
            //키워드 on일 경우
            if self.viewmodel.keywordOnOff.value {
                let KPPersent = item.persent ?? 0
                
                let goalPersent = self.viewmodel.goalPersent.value
                
                let restPersent = (goalPersent - KPPersent) * 100
                
                let highlight = String(format: "%2.f%%", restPersent > 0 ? restPersent : 0)
                
                cell.goalProgressBarView.titleLabel.text = "Q\(indexPath.row+1) 키워드 매칭률"
                
                cell.goalProgressBarView.progressBar.progress = KPPersent
                
                cell.keywordPersent.text = String(format: "%2.f%%", KPPersent * 100)
                
                cell.keywordLabel.text = item.keyword.joined(separator: "  ")
                
                cell.sttAnswer.attributedText = self.setKeywordHighlightAttributes(sttAnswer, keyword: item.keyword)
                
                cell.keywordLabel.attributedText = self.setKeywordHighlightAttributes(cell.keywordLabel.text!, keyword: item.keyword.filter { sttAnswer.contains($0) })
                
                cell.answerLabel.attributedText = self.setKeywordHighlightAttributes(item.answer, keyword: item.keyword.filter { sttAnswer.contains($0) })
                
                cell.goalProgressBarView.guideLabel.attributedText = self.setColorHighlightAttribute(text: "목표까지 \(highlight) 남았어요",
                                                                                                   highlightString: highlight,
                                                                                                   color: .point)
                cell.goalProgressBarView.persentLabel.text =  String(format: "%2.f", KPPersent*100) + "/100"
                
                let progressWidth = UIScreen.main.bounds.width - 60
                let newX =  progressWidth * goalPersent
                cell.goalProgressBarView.goalView.center.x = newX
                
            }
            return cell
        }
    }
}

//MARK: - CollectionViewLayout
extension KPDetailViewController {
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            layoutEnvironment: NSCollectionLayoutEnvironment)-> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                heightDimension: .estimated(self.view.frame.height)))
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(1.0)
                        
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsetsReference = .none
            return section
        }
        
        return layout
    }
}
