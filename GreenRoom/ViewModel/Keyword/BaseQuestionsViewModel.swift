//
//  BaseQuestionsViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/26.
//

import UIKit
import RxCocoa
import RxSwift

final class BaseQuestionsViewModel {
    private let disposeBag = DisposeBag()
    
    let referenceObservable = BehaviorRelay<ReferenceModel?>(value: nil) // 기본,그린룸 질문 1depth
    
    let baseQuestionsObservable = BehaviorRelay<[ReferenceQuestionModel]>(value: []) // 기본,그린룸 질문
    
    let selectedQuestionObservable = BehaviorRelay<ReferenceQuestionModel?>(value: nil) // 선택한 질문
    
    let filteringObservable = BehaviorRelay<String?>(value: nil) //필터링된 카테고리 observable
    
    let searchTextObservable = BehaviorRelay<String?>(value: nil) // 검색 키워드
    
    let hasNextPage = BehaviorRelay<Bool>(value: false) // 마지막 페이지인지 여부
    
    init() {
        KeywordPracticeService().fetchReferenceQuestions(categoryId: nil, title: nil, page: nil)
            .take(1)
            .bind(to: self.referenceObservable)
            .disposed(by: self.disposeBag)
        
        Observable // 필터링 또는 키워드 변경시
            .combineLatest(filteringObservable, searchTextObservable)
            .subscribe(onNext: { (ids,title) in
                KeywordPracticeService().fetchReferenceQuestions(categoryId: ids, title: title, page: nil)
                    .bind(onNext: { model in
                        self.baseQuestionsObservable.accept([])
                        self.referenceObservable.accept(model)
                    }).disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        referenceObservable
            .filter{ $0 != nil}
            .map { $0!.questions }
            .bind(onNext: { questions in
                var newQuestions = self.baseQuestionsObservable.value
                newQuestions.append(contentsOf: questions)
                self.baseQuestionsObservable.accept(newQuestions)
            }).disposed(by: disposeBag)
        
        referenceObservable
            .filter{ $0 != nil}
            .map { !($0!.currentPages == $0!.totalPages-1) }
            .bind(to: hasNextPage)
            .disposed(by: disposeBag)
    }
    
    func pagingQuestions(categoryId: Int, title: String, page: Int) {
        
    }
}
