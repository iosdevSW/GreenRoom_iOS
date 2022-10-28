//
//  FileringViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/02.
//

import UIKit
import RxSwift

final class FilteringViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let publicQuestionService: PublicQuestionService
    
    struct Input {
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let publicQuestions: Observable<[FilteringSectionModel]>
    }
    
    let categoryId: Int
    
    init(categoryId: Int, publicQuestionService: PublicQuestionService) {
        self.categoryId = categoryId
        self.publicQuestionService = publicQuestionService
    }
    
    func transform(input: Input) -> Output {
        
        let models = input.trigger.flatMap { _ in
            self.publicQuestionService.fetchFilteredQuestion(categoryId: self.categoryId)
                .withUnretained(self)
                .map { onwer, questions  in
                    return [FilteringSectionModel(
                        header:
                            Info(title: Category(rawValue: onwer.categoryId)?.title ?? "공통",
                                 subTitle: "관련된 질문리스트를 보여드려요!\n질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)"),
                        items: questions)
                    ]
                }
        }
        
        return Output(publicQuestions: models)
    }
}

