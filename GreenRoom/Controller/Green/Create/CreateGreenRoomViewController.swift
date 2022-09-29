//
//  CreateGreenRoomViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import UIKit
import RxSwift
import RxDataSources

final class CreateGreenRoomViewController: BaseViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel = CreateGRViewModel()

    private lazy var doneButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.setTitle("작성완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .mainColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissal))
    }
    
    override func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.view.addSubview(doneButton)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-35)
            make.height.equalTo(63)
        }
    }
    
    override func setupAttributes() {
        self.hideKeyboardWhenTapped()
        self.doneButton.isUserInteractionEnabled = false
        self.doneButton.alpha = 0.5
        configureCollectionView()
    }
    
    override func setupBinding() {
        
        collectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.collectionView.cellForItem(at: indexPath) as! CategoryCell
                let index = indexPath.row+1
                
                guard let category = CategoryID(rawValue: index) else { return }
                cell.frameView.layer.borderColor = UIColor.mainColor.cgColor
                cell.imageView.image = category.SelectedImage
                
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.collectionView.cellForItem(at: indexPath) as! CategoryCell
                let index = indexPath.row + 1
                
                guard let category = CategoryID(rawValue: index) else { return }
                cell.frameView.layer.borderColor = UIColor.customGray.cgColor
                cell.imageView.image = category.nonSelectedImage
                
            }).disposed(by: disposeBag)
        
        viewModel.categories.bind(to: self.collectionView.rx.items(dataSource: self.dataSource())).disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            let header = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: 0)) as! CreateGRHeaderView
            
            let input = CreateGRViewModel.Input(question: header.questionTextView.rx.text.orEmpty.asObservable(),
                                                returnTrigger: header.questionTextView.rx.didEndEditing.asObservable(),
                                                category: self.collectionView.rx.itemSelected.map { $0.row + 1}.asObservable(),
                                                submit: self.doneButton.rx.tap.asObservable())
            header.dateContainer.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    let vc = CustomPopUpDatePickerController(viewModel: self.viewModel)
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                }).disposed(by: self.disposeBag)
            
            let output = self.viewModel.transform(input: input)
            
            header.bind(date: output.comfirmDate.asObservable())
            
            output.isValid
                .bind(to: self.doneButton.rx.isEnabled)
                .disposed(by: self.disposeBag)
            
            output.isValid
                .map { $0 ? 1.0 : 0.5}
                .bind(to: self.doneButton.rx.alpha)
                .disposed(by: self.disposeBag)

            output.successMessage.emit(onNext: { [weak self] message in
                guard let self = self else { return }

                let alert = self.comfirmAlert(title: "작성 완료", subtitle: message) { _ in
                    self.dismiss(animated: true)
                }
                self.present(alert, animated: true)
            }).disposed(by: self.disposeBag)

            output.failMessage.emit(onNext: { [weak self] message in
                guard let self = self else { return }

                let alert = self.comfirmAlert(title: "작성 실패", subtitle: message) { _ in
                    print("다시 작성")
                }
                self.present(alert, animated: true)
            }).disposed(by: self.disposeBag)
        }
        
        
    }
    
    @objc func dismissal(){
        self.dismiss(animated: false)
    }
}

//MARK: - CollectionView
extension CreateGreenRoomViewController {
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - CGFloat(42 * 2) - (20 * 3)) / 4
        layout.itemSize = CGSize(width: cellWidth, height: 90)
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 42, bottom: 80, right: 42)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: view.bounds.height * 0.59)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.register(CreateGRHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CreateGRHeaderView.reuseIdentifier)
        collectionView.backgroundColor = .white
    }
    
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<CreateSection> {
        
        return RxCollectionViewSectionedReloadDataSource<CreateSection> {
            (dataSource, collectionView, indexPath, item) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
            
            guard let category = CategoryID(rawValue: indexPath.row + 1) else { return UICollectionViewCell() }
            cell.imageView.image = category.nonSelectedImage
            cell.titleLabel.text = category.title
                        
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CreateGRHeaderView.reuseIdentifier, for: indexPath) as? CreateGRHeaderView else { return UICollectionReusableView() }
            return headerView
        }
    }
}

//MARK: - Alert
extension CreateGreenRoomViewController {
    
    func comfirmAlert(title: String, subtitle: String,completion:@escaping(UIAlertAction) -> Void) -> UIAlertController{
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: completion))
        
        return alert
    }
}

