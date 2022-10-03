//
//  FileringViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/02.
//

import UIKit
import RxSwift

final class FilteringViewModel: ViewModelType {
    
    let publicQuestionService: PublicQuestionService
    var disposeBag = DisposeBag()
    
    struct Input {
        let categoryObservable: Observable<Int>
    }
    
    struct Output {
        let publicQuestions: Observable<[FilteringSectionModel]>
    }
    
    init(publicQuestionService: PublicQuestionService) {
        self.publicQuestionService = publicQuestionService
    }
    
    func transform(input: Input) -> Output {
        
        let models = input.categoryObservable.flatMap { categoryId in
            self.publicQuestionService.fetchFilteredQuestion(categoryId: categoryId)
                .map { questions in
                    return [FilteringSectionModel(header: Info(title: Category(rawValue: categoryId)?.title ?? "공통", subTitle: "관련된 질문리스트를 보여드려요!\n질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)"), items: questions)]
                }
        }
        
        return Output(publicQuestions: models)
    }
}

