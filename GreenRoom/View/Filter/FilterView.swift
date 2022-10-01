
//  FilterView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/06.
//

import UIKit
import RxSwift

final class FilterView: UIView {
    //MARK: - Properties
    let viewModel: CategoryViewModel
    let disposeBag = DisposeBag()
    
    private var selectedCategoriesCollectionView: UICollectionView!
    
    private let filterButton = UIButton(type: .roundedRect).then{
        $0.backgroundColor = .mainColor
        $0.setTitle("필터 ", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 12, family: .Semibold)
        $0.setImage(UIImage(named: "filter"), for: .normal)
        $0.tintColor = .white
        $0.semanticContentAttribute = .forceRightToLeft
        $0.layer.cornerRadius = 25/2
    }
    
    //MARK: - Init
    init(viewModel: CategoryViewModel){
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        self.configureCollectionView()
        self.configureUI()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Bind
    private func bind() {
        
        filterButton.rx.tap.subscribe(onNext: {
            NotificationCenter.default.post(name: .categoryObserver, object: nil, userInfo: ["viewModel": self.viewModel])
        }).disposed(by: disposeBag)
        
        viewModel.selectedCategoriesObservable.asObserver()
            .bind(to: self.selectedCategoriesCollectionView.rx.items(cellIdentifier: "ItemsCell", cellType: FilterItemsCell.self)) { index, id ,cell in
                cell.category = CategoryID(rawValue: id)
            }.disposed(by: disposeBag)
    }
    
    //MARK: - CofigureUI
    private func configureUI() {
        self.backgroundColor = .backgroundGray
        
        self.addSubview(self.filterButton)
        self.filterButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(40)
            make.height.equalTo(27)
            make.width.equalTo(60)
        }
        
        
        self.addSubview(selectedCategoriesCollectionView)
        selectedCategoriesCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(filterButton.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
    }
    
    private func configureCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        
        self.selectedCategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        selectedCategoriesCollectionView.backgroundColor = .clear
        selectedCategoriesCollectionView.register(FilterItemsCell.self, forCellWithReuseIdentifier: "ItemsCell")
        selectedCategoriesCollectionView.delegate = self
    }

}


extension FilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tempLabel = UILabel()
        
        self.viewModel.selectedCategoriesObservable
            .take(1)
            .subscribe(onNext: { items in
                let id = items[indexPath.item]
                let category = CategoryID(rawValue: id)
                
                tempLabel.font = .sfPro(size: 12, family: .Regular)
                tempLabel.text = category?.title
            }).disposed(by: disposeBag)
        
        return CGSize(width: tempLabel.intrinsicContentSize.width, height: 22)
    }
}
