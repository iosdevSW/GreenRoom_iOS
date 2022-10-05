//
//  BaseQuestionsViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/26.
//

import UIKit
import RxCocoa
import RxSwift

class BaseQuestionsViewModel {
    let disposeBag = DisposeBag()
    
    let baseQuestionsObservable = BehaviorSubject<[ReferenceQuestionModel]>(value: []) // 기본,그린룸 질문
    
    let selectedQuestionObservable = BehaviorRelay<ReferenceQuestionModel?>(value: nil) // 선택한 질문
    
    let filteringObservable = BehaviorRelay<String?>(value: nil) //필터링된 카테고리 observable
    
    init() {
        KeywordPracticeService().fetchReferenceQuestions(categoryId: nil, title: nil, page: nil)
            .bind(to: baseQuestionsObservable)
            .disposed(by: disposeBag)
        
        filteringObservable
            .subscribe(onNext: { ids in
                KeywordPracticeService().fetchReferenceQuestions(categoryId: ids, title: nil, page: nil)
                    .bind(to: self.baseQuestionsObservable)
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    func pagingQuestions(categoryId: Int, title: String, page: Int) {
        
    }
}
