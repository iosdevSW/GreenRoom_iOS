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

final class RecentPublicQuestionsViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel: RecentPublicQuestionsViewModel!
    
    init(viewModel: RecentPublicQuestionsViewModel){
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(handleDismissal))
        self.navigationController?.navigationBar.tintColor = .mainColor
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
        super.configureUI()
        
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
        let input = RecentPublicQuestionsViewModel.Input(trigger: rx.viewWillAppear.asObservable())
        let output = self.viewModel.transform(input: input)
        
        output.recent.bind(to: collectionView.rx.items(dataSource: dataSource())).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(GreenRoomSectionModel.Item.self)
            .subscribe(onNext: { question in
                switch question {
                case .recent(question: let question):
                    let vc = PublicAnswerListViewController(viewModel: PublicAnswerViewModel(id: question.id, scrapService: ScrapService(), publicQuestionService: PublicQuestionService()))
                    self.navigationController?.pushViewController(vc, animated: false)
                default: return
                }
                
            }).disposed(by: disposeBag)
    }
    
    @objc func handleDismissal() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension RecentPublicQuestionsViewController {
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height/8)
        layout.headerReferenceSize = CGSize(width: view.bounds.width , height: view.bounds.height * 0.25)
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InfoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderView.reuseIdentifier)
        collectionView.register(PublicQuestionsCell.self, forCellWithReuseIdentifier: PublicQuestionsCell.reuseIdentifier)
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<GreenRoomSectionModel> {
            (dataSource, collectionView, indexPath, item) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublicQuestionsCell.reuseIdentifier, for: indexPath) as? PublicQuestionsCell else { return UICollectionViewCell() }
            
            switch item {
            case .recent(question: let question):
                cell.configure(question: question)
                return cell
            default: return UICollectionViewCell()
            }
            
        } configureSupplementaryView: { dataSource, collectionView, kind,
            indexPath in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderView.reuseIdentifier, for: indexPath) as? InfoHeaderView else {
                    return UICollectionReusableView()
            }
            header.filterShowing = true
            header.info = Info(title: "최근 질문", subTitle: "방금 올라온 모든 질문리스트를 보여드려요!\n질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)")
            return header
        }
    }
}
