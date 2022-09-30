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
    
    let baseQuestionsObservable = BehaviorSubject<[QuestionModel]>(value: []) // 기본,그린룸 질문
    let selectedQuestionObservable = PublishSubject<QuestionModel>() // 선택한 질문
    let filteringObservable = PublishSubject<String>() //필터링된 카테고리 observable
    
    init() {
        KeywordPracticeService().fetchReferenceQuestions(categoryId: nil, title: nil)
            .bind(to: baseQuestionsObservable)
            .disposed(by: disposeBag)
        
        filteringObservable
            .subscribe(onNext: { ids in
                KeywordPracticeService().fetchReferenceQuestions(categoryId: ids, title: nil)
                    .bind(to: self.baseQuestionsObservable)
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}
