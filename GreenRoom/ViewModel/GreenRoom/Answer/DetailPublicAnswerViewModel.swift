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
    
    private let repository: DetailPublicAnswerRepository
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let header: Observable<QuestionHeader>
        let answer: Observable<SpecificPublicAnswer>
    }
    
    private let detailPublicAnswer = PublishSubject<SpecificPublicAnswer>()
    
    private let question: QuestionHeader
    private let id: Int
    
    init(question: QuestionHeader,
         answerID: Int,
         repository: DetailPublicAnswerRepository
    ){
        self.question = question
        self.id = answerID
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        
        input.trigger
            .withUnretained(self)
            .flatMap { onwer, _ in
                onwer.repository.fetchDetailAnswer(id: onwer.id)
            }.bind(to: detailPublicAnswer)
            .disposed(by: disposeBag)

        return Output(
            header: Observable.just(question),
            answer: self.detailPublicAnswer.asObservable()
        )
    }
}
