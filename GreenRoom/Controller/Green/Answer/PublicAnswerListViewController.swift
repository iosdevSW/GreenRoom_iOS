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

/// 그린룸 질문을 클릭했을 때 나오는 리스트뷰
final class PublicAnswerListViewController: BaseViewController {
    
    //MARK: - Properties
    private var mode: PublicAnswerMode = .notPermission {
        didSet { setButtonAttribute() }
    }
     
    private let viewModel: PublicAnswerViewModel
    
    private lazy var input = PublicAnswerViewModel.Input(
        scrapButtonTrigger: scrapButton.rx.tap.asObservable()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance),
        registerGreenRoomTrigger: boxButton.rx.tap.asObservable()
    )
    
    private lazy var output = viewModel.transform(input: input)
    private lazy var timeOutView = TimeOutView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    private lazy var headerView = AnswerHeaderView(frame: .zero)
    
    private lazy var answerPostButton = UIButton().then {
        $0.backgroundColor = .point
        $0.setTitle("참여하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.layer.cornerRadius = 8
    }
    
    private var starImage: UIImage? {
        return UIImage(systemName: "star")
    }
    
    private var starFillImage: UIImage? {
        return UIImage(systemName: "star.fill")
    }
    
    private lazy var scrapButton = UIButton().then {
        $0.setImage(starImage, for: .normal)
        $0.imageView?.tintColor = .white
    }
    
    private lazy var boxButton = UIButton().then {
        $0.setImage(UIImage(named: "box"), for: .normal)
        $0.imageView?.tintColor = .white
    }
    
    // MARK: - LifeCycle
    init(viewModel: PublicAnswerViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: boxButton),
            UIBarButtonItem(customView: scrapButton)
        ]
        
        self.hideTabbar()
        self.configureNavigationBackButtonItem(tintColor: .white)
    }

    override func setupAttributes() {
        super.setupAttributes()
        
        self.configureCollectionView()
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
        
        self.view.addSubviews([collectionView, answerPostButton, timeOutView])
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        answerPostButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        timeOutView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(answerPostButton.snp.top).offset(-16)
            make.width.equalTo(110)
            make.height.equalTo(45)
        }
    }
    
    override func setupBinding() {
        
        output.scrapUpdateState
            .withUnretained(self)
            .subscribe(onNext: { onwer, completable in
                let scrapImage = completable ? onwer.starFillImage : onwer.starImage
                onwer.scrapButton.setImage(scrapImage, for: .normal)
            }).disposed(by: disposeBag)
        
        output.answer
            .withUnretained(self)
            .subscribe(onNext: { onwer, answer in
                onwer.headerView.question = QuestionHeader(id: answer.header.id, question: answer.header.question, categoryName: answer.header.categoryName, groupCategoryName: answer.header.categoryName)
                onwer.collectionView.alpha = answer.header.mode == .permission ? 1.0 : 0.5
                onwer.mode = answer.header.mode
                onwer.timeOutView.configure(time: answer.header.expiredAt)
                onwer.scrapButton.setImage(answer.header.scrap ? onwer.starFillImage : onwer.starImage, for: .normal)
            }).disposed(by: disposeBag)
        
        output.answer
            .toArray()
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        answerPostButton.rx.tap
            .withLatestFrom(output.answer)
            .withUnretained(self)
            .subscribe(onNext: { onwer, answer in
                let vc = ApplyPublicAnswerViewController(viewModel: MakePublicAnswerViewModel(answer: answer, repository: DefaultApplyPublicAnswerRepository()))
                onwer.navigationController?.pushViewController(vc, animated: false)
            }).disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(PublicAnswerSectionModel.Item.self)
            .withUnretained(self)
            .subscribe(onNext: { onwer, item in
                let viewModel = DetailPublicAnswerViewModel(
                    question: self.headerView.question,
                    answerID: item.id,
                    repository: DefaultDetailPublicAnswerRepository())
                
                let vc = DetailPublicAnswerViewController(viewModel: viewModel)
                onwer.navigationController?.pushViewController(vc, animated: false)
            }).disposed(by: disposeBag)
    }
}

//MARK: - CollectionView
extension PublicAnswerListViewController {
    
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width, height: 70)
        layout.minimumLineSpacing = 15
        
        return layout
    }
    
    private func configureCollectionView() {
        collectionView.register(PublicAnswerCell.self, forCellWithReuseIdentifier: PublicAnswerCell.reuseIdentifier)
        collectionView.register(PublicAnswerStatusHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PublicAnswerStatusHeaderView.reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<PublicAnswerSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<PublicAnswerSectionModel> { [weak self] (dataSource, collectionView, indexPath, item) in
            guard let self else { return UICollectionViewCell() }
            guard let cell = collectionView.dequeueCell(PublicAnswerCell.self, for: indexPath) else { return UICollectionViewCell() }
            cell.isReversed = indexPath.row % 2 != 0
            cell.question = self.mode == .permission ? item : nil
            
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return self.mode == .permission ? CGSize(width: self.view.frame.width, height: 100) : .zero    
    }
}

//MARK: - Mode
extension PublicAnswerListViewController {
    
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
