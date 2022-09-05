//
//  PracticeDetailViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/30.
//

import UIKit
import RxDataSources
import RxSwift

class KPDetailViewController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView!
    let viewmodel: KeywordViewModel
    let disposeBag = DisposeBag()
    
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
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarColor(.customGray.withAlphaComponent(0.1))
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
    func bind() {
        self.viewmodel.selectedQ
            .bind(to: self.collectionView.rx.items(dataSource: self.configureDataSource()))
            .disposed(by: self.disposeBag)
    }
    
    //MARK: - ConfigureUI
    func configureUI() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.generateLayout()).then {
            $0.backgroundColor = .white
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
            cell.keywordIsOn = self.viewmodel.keywordOnOff
            
            let type: RecordingType =  self.viewmodel.cameraOnOff == true ? .camera : .mike
            cell.goalProgressBarView.buttonImage = type
            //키워드 on일 경우
            if self.viewmodel.keywordOnOff {
                cell.goalProgressBarView.titleLabel.text = "Q\(indexPath.row+1) 키워드 매칭률"
                cell.keywordPersent.text = "75%"
                cell.keywordLabel.text = "천진난만 현실적 적극적 테스트적 끄적끄적"
                
                if let per = self.viewmodel.goalPersent {
                    let progressWidth = UIScreen.main.bounds.width - 60
                    let newX =  progressWidth * per
                    cell.goalProgressBarView.goalView.center.x = newX
                }
            }
            
            let title = self.viewmodel.selectedQuestionTemp[indexPath.row]
            cell.questionLabel.text = "Q\(indexPath.row+1)\n\(title)"
            cell.categoryLabel.text = "공통"
            cell.sttAnswer.text = "다각적인 소통법으로 구성원의 적극적 참여를 끌어낸 경험이 있습니다. OO 기업 상품기획팀 인턴 당시, 팀 공동 과제로 브랜드 기획을 맡았습니다. 천진난만한 성격으로 자연스레 리더를 도맡았고 자료를 공유하며 동기부여하기 위해 노력한 결과 장군감이다라는 수식어를 얻었습니다."
            cell.answerLabel.text = "다각적인 소통법으로 구성원의 적극적 참여를 끌어낸 경험이 있습니다. OO 기업 상품기획팀 인턴 당시, 팀 공동 과제로 브랜드 기획을 맡았습니다. 천진난만한 성격으로 자연스레 리더를 도맡았고 자료를 공유하며 동기부여하기 위해 노력한 결과 현실적이다라는 수식어를 얻었습니다."
            
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
                heightDimension: .fractionalHeight(1.0)
                        
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
