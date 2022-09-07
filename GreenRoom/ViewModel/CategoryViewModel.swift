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
    
    let filteringObservable = BehaviorSubject<[Int]>(value: [])
    
    let selectedCategoriesObservable = BehaviorSubject<[Int]>(value: [1])
    
    var selectedCategories: [Int] = [1]{
        didSet{
            selectedCategoriesObservable.onNext(self.selectedCategories)
        }
    }
//
//    init(){
//        filteringObservable.bind(to: selectedCategoriesObservable).disposed(by: disposeBag)
//    }
}
