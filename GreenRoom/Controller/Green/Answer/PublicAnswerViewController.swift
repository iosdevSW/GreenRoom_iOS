//
//  PublicAnswerViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class PublicAnswerViewController: BaseViewController {
    
    //MARK: - Properties
    private var mode: PublicAnswerMode = .notPermission {
        didSet { setButtonAttribute() }
    }
    
    private let viewModel: PublicAnswerViewModel
    
    private lazy var input = PublicAnswerViewModel.Input(scrapButtonTrigger: scrapButton.rx.tap.asObservable(),
                                            registerGreenRoomTrigger: boxButton.rx.tap.asObservable())
    
    private lazy var output = viewModel.transform(input: input)
    
    private var collectionView: UICollectionView!
    private var headerView = QuestionHeaderView(frame: .zero)
    
    private var answerPostButton = UIButton().then {
        $0.backgroundColor = .point
        $0.setTitle("참여하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.layer.cornerRadius = 8
    }
    
    private let scrapButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.imageView?.tintColor = .white
    }
     
    private let boxButton = UIButton().then {
        $0.setImage(UIImage(named: "box"), for: .normal)
        $0.imageView?.tintColor = .white
    }
    
    init(viewModel: PublicAnswerViewModel){
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

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(handleDismissal))
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: boxButton),
            UIBarButtonItem(customView: scrapButton)
        ]
        
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
    
    override func setupAttributes() {
        self.configureCollectionView()
        self.hideKeyboardWhenTapped()
    }
    
    override func configureUI() {
        super.configureUI()

        let headerHeight = UIScreen.main.bounds.height * 0.3
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        let buttonHeight = view.frame.size.height * 0.07
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        

        self.view.addSubview(answerPostButton)
        answerPostButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupBinding() {
        
        output.scrapUpdateState
            .subscribe(onNext: { completable in
                self.scrapButton.setImage(UIImage(systemName: completable ? "star.fill" : "star"), for: .normal)
            }).disposed(by: disposeBag)
        
        output.answer
            .subscribe(onNext: { [weak self] answer in
            guard let self = self else { return }
            self.headerView.question = Question(id: answer.header.id, question: answer.header.question, categoryName: answer.header.categoryName, groupCategoryName: answer.header.categoryName)
            self.collectionView.alpha = answer.header.mode == .permission ? 1.0 : 0.5
            self.mode = answer.header.mode
            self.scrapButton.setImage(UIImage(systemName: answer.header.scrap ? "star.fill" : "star"), for: .normal)
            
        }).disposed(by: disposeBag)
        
        output.answer.map{ [$0] }.bind(to: collectionView.rx.items(dataSource: dataSource())).disposed(by: disposeBag)
        
        answerPostButton.rx.tap
            .withLatestFrom(output.answer)
            .subscribe(onNext: { [weak self] answer in
                let vc = MakePublicAnswerViewController(viewModel: MakePublicAnswerViewModel(answer: answer, publicQuestionService: PublicQuestionService()))
                self?.navigationController?.pushViewController(vc, animated: false)
        }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Selector
    @objc func handleDismissal(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - CollectionView
extension PublicAnswerViewController {
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width, height: 70)
        layout.minimumLineSpacing = 15
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 100)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PublicAnswerCell.self, forCellWithReuseIdentifier: PublicAnswerCell.reuseIdentifier)
        collectionView.register(PublicAnswerStatusHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PublicAnswerStatusHeaderView.reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<PublicAnswerSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<PublicAnswerSectionModel> { [weak self] (dataSource, collectionView, indexPath, item) in
     
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublicAnswerCell.reuseIdentifier, for: indexPath) as? PublicAnswerCell else { return UICollectionViewCell() }
            cell.isReversed = indexPath.row % 2 != 0
            cell.question = self?.mode == .permission ? item : nil
            
            return cell
            
        } configureSupplementaryView: { dataSource, collectionView, kind,
            indexPath in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PublicAnswerStatusHeaderView.reuseIdentifier, for: indexPath) as? PublicAnswerStatusHeaderView else {
                    return UICollectionReusableView()
            }
            header.question = dataSource[0].header
            return header
        }
    }
}

//MARK: - Mode
extension PublicAnswerViewController {
    
    private func setButtonAttribute() {
        switch mode {
        case .permission:
            self.answerPostButton.removeFromSuperview()
        case .notPermission:
            self.answerPostButton.backgroundColor = .point
        case .expires:
            self.answerPostButton.setTitleColor(.mainColor, for: .normal)
            self.answerPostButton.backgroundColor = .white
            self.answerPostButton.layer.borderColor = UIColor.mainColor.cgColor
            self.answerPostButton.layer.borderWidth = 1
            self.answerPostButton.alpha = 0.3
        case .participated:
            self.answerPostButton.backgroundColor = .mainColor
            self.answerPostButton.setTitle("참여 완료", for: .normal)
            self.answerPostButton.isEnabled = false
        }
    }
}
