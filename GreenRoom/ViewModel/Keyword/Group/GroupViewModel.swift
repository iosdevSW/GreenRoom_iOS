//
//  GroupViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/10/02.
//

import UIKit
import RxSwift
import RxCocoa

class GroupViewModel {
    let disposeBag = DisposeBag()
    
    let groupsObservable = BehaviorRelay<[GroupModel]>(value: [])
    
    let groupCounting = PublishSubject<Int>()    
    
    init(){
        groupsObservable.asObservable()
            .map{ $0.count }
            .bind(to: groupCounting)
            .disposed(by: disposeBag)
    }
    
    func updateGroupList(){
        KeywordPracticeService().fetchGroupList()
            .bind(to: groupsObservable)
            .disposed(by: disposeBag)
    }
}
