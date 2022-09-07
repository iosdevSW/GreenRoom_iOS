
//  FilterView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/06.
//

import UIKit
import RxSwift

protocol FilterViewDeleagte {
    func didTapFilterButton()
}

class FilterView: UIView{
    //MARK: - Properties
    let viewModel: CategoryViewModel
    let disposeBag = DisposeBag()
    
    var delegate: FilterViewDeleagte?
    
    var selectedCategoriesCollectionView: UICollectionView!
    
    let filterButton = UIButton(type: .roundedRect).then{
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
        
        filterButton.rx.tap.subscribe(onNext: {
            NotificationCenter.default.post(name: Notification.Name("Category"), object: nil, userInfo: ["viewModel": self.viewModel])
        }).disposed(by: disposeBag)
        
        viewModel.selectedCategoriesObservable.asObserver()
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
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(27)
            make.width.equalTo(60)
        }
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 16
        }
        
        self.selectedCategoriesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then{
            $0.backgroundColor = .clear
            $0.register(FilterItemsCell.self, forCellWithReuseIdentifier: "ItemsCell")
            $0.delegate = self
            
            self.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(filterButton.snp.bottom).offset(6)
                make.leading.equalTo(filterButton.snp.leading)
                make.trailing.equalToSuperview()
//                make.height.equalTo(bounds.height * 3/8)
                make.bottom.equalToSuperview().offset(-6)
            }
        }
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
