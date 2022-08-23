//
//  KeywordViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import RxCocoa
import RxSwift

class KeywordViewModel {
    let filteringObservable = PublishSubject<[Int]>()
    
    var filteringList = [Int]() {
        didSet{
            filteringObservable.onNext(filteringList)
        }
    }
    
}
