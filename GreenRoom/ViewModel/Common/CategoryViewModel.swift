//
//  CategoryViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/18.
//

import RxSwift
import RxCocoa

class CategoryViewModel {
    
    var disposeBag = DisposeBag()
    
    let categories = Observable.of(["공통","인턴","대외활동","디자인","경영기획","회계","생산/품질관리","인사","마케팅","영업","IT/개발","연구개발(R&D)"])
    
    let tempSelectedCategoriesObservable = BehaviorRelay<[Int]>(value: []) // SelectedViewController의 collectionView Binding을 위한 옵저버블
    
    let selectedCategoriesObservable = BehaviorSubject<[Int]>(value: []) // filterView에서 실제 filtering하고있는 카테고리 ids
    
    let selectedCategoryObservable = BehaviorRelay<Int>(value: -1)
    
}
