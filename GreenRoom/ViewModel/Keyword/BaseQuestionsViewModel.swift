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
    
    let nextPage = BehaviorRelay<Int>(value: 0) // 다음 페이지
    
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
        
        self.baseQuestionsObservable
            .map { $0.count}
            .bind(onNext: { questionCnt in
                var page = questionCnt / 20  // 1페이지당 질문 20개
                if questionCnt % 20 != 0 { page += 1 }
                self.nextPage.accept(page)
            }).disposed(by: disposeBag)
    }
    
    func pagingQuestions(categoryId: Int, title: String, page: Int) {
        
    }
}
