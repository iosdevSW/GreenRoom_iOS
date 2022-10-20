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
        let answer: Observable<SpecificPublicAnswer>
    }
    
    private let detailPublicAnswer = PublishSubject<SpecificPublicAnswer>()
    
    let questionID: Int
    
    init(questionID: Int,
         publicQuestionService: PublicQuestionService
    ){
        self.questionID = questionID
        self.publicQuestionService = publicQuestionService
    }
    
    func transform(input: Input) -> Output {
        
        publicQuestionService.fetchDetailAnswer(id: self.questionID)
            .bind(to: detailPublicAnswer)
            .disposed(by: disposeBag)
        
        return Output(answer: self.detailPublicAnswer.asObservable())
    }
}
