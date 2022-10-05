//
//  CategorySelectViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/07.
//

import UIKit
import RxSwift
import RxCocoa

final class CategorySelectViewController: BaseViewController {
    
    //MARK: - Properties
    var viewModel: CategoryViewModel!
    
    private var blurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .dark)
        $0.alpha = 0.3
    }
    
    private var categoryCollectionView: UICollectionView!
    private var selectedCategoriesCollectionView: UICollectionView!
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }
    
    private let titleLabel = UILabel().then{
        $0.text = "직무 필터링"
        $0.textColor = .black
        $0.font = .sfPro(size: 16, family: .Semibold)
    }
    
    private lazy var applyButton = UIButton(type: .system).then{
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .mainColor
        $0.addTarget(self, action: #selector(didClickApplyButton(_:)), for: .touchUpInside)
    }
    
    private lazy var cancelButton = UIButton(type: .system).then{
        $0.setTitle("선택취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.layer.cornerRadius = 30
        $0.backgroundColor = .customGray
        $0.addTarget(self, action: #selector(didClickCancelButton(_:)), for: .touchUpInside)
    }
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupAttributes() {
        self.configureCollectionView() 
    }
    
    //MARK: - Selector
    @objc func didClickCancelButton(_ sender: UIButton) {
        self.viewModel.selectedCategoriesObservable
            .take(1)
            .subscribe(onNext:{ ids in
                self.viewModel.tempSelectedCategoriesObservable
                    .accept(ids)
            }).disposed(by: disposeBag)
        
        self.dismiss(animated: false)
    }
    
    @objc func didClickApplyButton(_ sender: UIButton) {
        self.viewModel.selectedCategoriesObservable
            .onNext(viewModel.tempSelectedCategoriesObservable.value)
        self.dismiss(animated: false)
    }
    
    //MARK: - Configure
    override func configureUI(){
        
        self.view.addSubview(blurView)
        self.blurView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(43)
            make.leading.equalToSuperview().offset(41)
        }
        
        self.containerView.addSubview(selectedCategoriesCollectionView)
        selectedCategoriesCollectionView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(43)
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.trailing.equalToSuperview().offset(-43)
            make.height.equalTo(22)
        }
        
        self.containerView.addSubview(categoryCollectionView)
        categoryCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(62)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.61)
        }
        
        
        self.containerView.addSubview(cancelButton)
        self.cancelButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(60)
            make.width.equalTo(150)
        }
        
        self.containerView.addSubview(applyButton)
        self.applyButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalTo(cancelButton.snp.trailing).offset(20)
            make.height.equalTo(60)
        }
    }
    
    //MARK: - Bind
    override func setupBinding() {
        categoryCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.categoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                cell.isSelected = true
                
                if var ids = self?.viewModel.tempSelectedCategoriesObservable.value {
                    ids.append(indexPath.row + 1)
                    self?.viewModel.tempSelectedCategoriesObservable.accept(ids)
                }
                
            }).disposed(by: disposeBag)
        
        categoryCollectionView.rx.itemDeselected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.categoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                cell.isSelected = false
                
                guard var ids = self?.viewModel.tempSelectedCategoriesObservable.value else { return }
                
                if let index = ids.firstIndex(of: indexPath.row + 1) {
                    ids.remove(at: index)
                    self?.viewModel.tempSelectedCategoriesObservable.accept(ids)
                }
                
            }).disposed(by: disposeBag)

        self.viewModel.categories
            .bind(to: self.categoryCollectionView.rx.items(cellIdentifier: "categoryCell", cellType: CategoryCell.self)) {index, title ,cell in
                guard let category = Category(rawValue: index+1) else { return }
                cell.category = category
                
                let ids = self.viewModel.tempSelectedCategoriesObservable.value
                if ids.contains(index + 1) {
                    cell.isSelected = true
                    self.categoryCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredVertically)
                }
                
            }.disposed(by: disposeBag)
        
        self.viewModel.tempSelectedCategoriesObservable
            .bind(to: self.selectedCategoriesCollectionView.rx.items(cellIdentifier: "ItemsCell", cellType: FilterItemsCell.self)) { index, id, cell in
                cell.category = Category(rawValue: id)
            }.disposed(by: disposeBag)
    }
}

//MARK: - collectionView
extension CategorySelectViewController {
    
    private func configureCollectionView() {
        
        let width = view.bounds.size.width
        
        let filteringLayout = UICollectionViewFlowLayout().then{
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 10
        }
        
        self.selectedCategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: filteringLayout).then{
            $0.backgroundColor = .white
            $0.register(FilterItemsCell.self, forCellWithReuseIdentifier: "ItemsCell")
            $0.allowsSelection = true
            $0.delegate = self
        }
        selectedCategoriesCollectionView.showsVerticalScrollIndicator = false
        
        
        let layout = UICollectionViewFlowLayout().then{
            let cellSize = width * 0.15
            let spacing = width / 20
            
            $0.minimumLineSpacing = width / 15
            $0.minimumInteritemSpacing = spacing
            
            $0.itemSize = CGSize(width: cellSize, height: cellSize)
        }
        
        self.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.allowsMultipleSelection = true
            $0.allowsSelection = true
            $0.contentInset = UIEdgeInsets(top: 10, left: width/10, bottom: 10, right: width/10)
            $0.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
            $0.backgroundColor = .white
        }
        
    }
}

extension CategorySelectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let id = self.viewModel.tempSelectedCategoriesObservable.value[indexPath.item]
        let category = Category(rawValue: id)
        
        let tempLabel = UILabel()
        tempLabel.font = .sfPro(size: 12, family: .Regular)
        tempLabel.text = category?.title
        
        return CGSize(width: tempLabel.intrinsicContentSize.width, height: 22)
    }
}
