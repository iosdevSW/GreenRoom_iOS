//
//  DetailPublicAnswerViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/18.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailPublicAnswerViewModel: ViewModelType {
    
    private let publicQuestionService: PublicQuestionService
    
    var disposeBag = DisposeBag()
    
    struct Input { }
    
    struct Output {
        let header: Observable<QuestionHeader>
        let answer: Observable<SpecificPublicAnswer>
    }
    
    private let detailPublicAnswer = PublishSubject<SpecificPublicAnswer>()
    
    let question: QuestionHeader
    let id: Int
    
    init(question: QuestionHeader,
         answerID: Int,
         publicQuestionService: PublicQuestionService
    ){
        self.question = question
        self.id = answerID
        self.publicQuestionService = publicQuestionService
    }
    
    func transform(input: Input) -> Output {
        
        publicQuestionService.fetchDetailAnswer(id: self.id)
            .bind(to: detailPublicAnswer)
            .disposed(by: disposeBag)
        
        return Output(
            header: Observable.just(question),
            answer: self.detailPublicAnswer.asObservable()
        )
    }
}
