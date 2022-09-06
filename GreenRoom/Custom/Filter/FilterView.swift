
//  FilterView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/06.
//

import UIKit
import RxSwift

class FilterView: UIView{
    //MARK: - Properties
    let viewModel: CategoryViewModel
    let disposeBag = DisposeBag()
    
    var selectedCategoriesCollectionView: UICollectionView!
    
    let filterButton = UIButton(type: .roundedRect).then{
        $0.backgroundColor = .mainColor
        $0.setTitle("필터 ", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 12, family: .Semibold)
        $0.setImage(UIImage(named: "filter"), for: .normal)
        $0.tintColor = .white
        $0.semanticContentAttribute = .forceRightToLeft
        $0.layer.cornerRadius = 15
    }
    
    //MARK: - Init
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.configureUI()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Bind
    private func bind() {
        viewModel.filteringObservable.asObserver()
            .bind(to: self.selectedCategoriesCollectionView.rx.items(cellIdentifier: "ItemsCell", cellType: FilterItemsCell.self)) {index, id ,cell in
                guard let category = CategoryID(rawValue: id) else { return }
                let attributedString = NSMutableAttributedString.init(string: category.title)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: category.title.count))
                cell.itemLabel.attributedText = attributedString
            }.disposed(by: disposeBag)
    }
    
    //MARK: - CofigureUI
    private func configureUI() {
        self.addSubview(self.filterButton)
        self.filterButton.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(27)
            make.width.equalTo(63)
        }
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.scrollDirection = .horizontal
            $0.minimumLineSpacing = 16
        }
        
        self.selectedCategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then{
            $0.backgroundColor = .white
            $0.register(FilterItemsCell.self, forCellWithReuseIdentifier: "ItemsCell")
            $0.delegate = self
            
            self.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(filterButton.snp.bottom).offset(12)
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.height.equalTo(22)
            }
        }
    }
}

extension FilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tempLabel = UILabel()
        
        self.viewModel.filteringObservable
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
