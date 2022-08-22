//
//  CategoryFilterView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/22.
//

import UIKit
import RxCocoa
import RxSwift
// 필터링뷰 고쳐야함!!
class CategoryFilterView: UIView {
    //MARK: - Properties
    let viewModel = CategoryViewModel()
    let disposeBag = DisposeBag()
    
    let margin = 42
    var selectedCategories: Set<Int> = []{
        didSet{
            selectedCategoriesObservable.onNext(Array(self.selectedCategories))
        }
    }
    var selectedCategoriesObservable = PublishSubject<[Int]>()
    
    let titleLabel = UILabel().then{
        $0.text = "직무 필터링"
        $0.textColor = .black
        $0.font = .sfPro(size: 16, family: .Semibold)
    }
    
    var categoryCollectionView: UICollectionView!
    
    var filteringCollectionView: UICollectionView!
    
    let applyButton = UIButton(type: .system).then{
        $0.setTitle("적용하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.backgroundColor = .mainColor
    }
    
    let cancelButton = UIButton(type: .system).then{
        $0.setTitle("선택취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        $0.backgroundColor = .customGray
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner) // 위 양옆 모서리만 둥글게
        
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Bind
    func bind(){
        self.categoryCollectionView.rx.itemSelected
            .bind(onNext: { indexPath in
                let cell = self.categoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                let id = indexPath.row+1
                
                guard let category = CategoryID(rawValue: id) else { return }
                cell.frameView.layer.borderColor = UIColor.mainColor.cgColor
                cell.imageView.image = category.SelectedImage
                
                self.selectedCategories.insert(id)
                print(self.selectedCategories)
                
        }).disposed(by: disposeBag)
        
        self.categoryCollectionView.rx.itemDeselected
            .bind(onNext: { indexPath in
                let cell = self.categoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                let id = indexPath.row+1
                
                guard let category = CategoryID(rawValue: id) else { return }
                cell.frameView.layer.borderColor = UIColor.customGray.cgColor
                cell.imageView.image = category.nonSelectedImage
                
                self.selectedCategories.remove(id)
                
            }).disposed(by: disposeBag)
        
        self.viewModel.categories
            .bind(to: self.categoryCollectionView.rx.items(cellIdentifier: "categoryCell", cellType: CategoryCell.self)) {index, title ,cell in
                guard let category = CategoryID(rawValue: index+1) else { return }
                cell.imageView.image = category.nonSelectedImage
                cell.titleLabel.text = category.title
            }.disposed(by: disposeBag)
        
        self.selectedCategoriesObservable
            .bind(to: self.filteringCollectionView.rx.items(cellIdentifier: "ItemsCell", cellType: FilterItemsCell.self)) { index, id, cell in
                guard let category = CategoryID(rawValue: id) else { return }
                cell.itemLabel.text = category.title
            }
    }
    
    //MARK: - ConfigureUI
    func configureUI(){
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(43)
            make.leading.equalToSuperview().offset(41)
        }
        
        let layout = UICollectionViewFlowLayout().then{
            $0.minimumLineSpacing = 16
            $0.minimumInteritemSpacing = 20
            let screenWidth = UIScreen.main.bounds.width
            let cellWidth = (screenWidth - CGFloat(margin*2) - (20*3)) / 4
            $0.itemSize = CGSize(width: cellWidth, height: 90)
        }
        
        self.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.allowsMultipleSelection = true
            $0.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
            $0.backgroundColor = .white
            
            self.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(titleLabel.snp.bottom).offset(margin+20)
                make.leading.equalToSuperview().offset(margin)
                make.trailing.equalToSuperview().offset(-margin)
                make.height.equalTo(318)
            }
        }
        
        self.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(86)
            make.width.equalTo(170)
        }
        
        self.addSubview(self.applyButton)
        self.applyButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.leading.equalTo(cancelButton.snp.trailing).offset(5)
            make.height.equalTo(86)
        }
        
        let filteringLayout = UICollectionViewFlowLayout().then{
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 16
        }
        
        self.filteringCollectionView = UICollectionView(frame: .zero, collectionViewLayout: filteringLayout).then{
            $0.backgroundColor = .white
            $0.register(FilterItemsCell.self, forCellWithReuseIdentifier: "ItemsCell")
            
            self.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(43)
                make.top.equalTo(titleLabel.snp.bottom).offset(25)
                make.trailing.equalToSuperview().offset(-43)
                make.height.equalTo(22)
            }
        }
    }
}
