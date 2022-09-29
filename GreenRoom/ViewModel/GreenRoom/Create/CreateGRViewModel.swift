//
//  CreateGRViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/17.
//

import Foundation
import RxSwift
import RxCocoa


final class CreateGRViewModel: ViewModelType {
    
    let questionService = GreenRoomQuestionService()
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let question: Observable<String>
        let returnTrigger: Observable<Void>
        let category: Observable<Int>
        let submit: Observable<Void>
    }
    
    struct Output {
//        let categories: Observable<[String]>
        let isValid: Observable<Bool>
        let failMessage: Signal<String>
        let successMessage: Signal<String>
        let comfirmDate: Observable<Int>
    }
    
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    private let tempQuestion = PublishSubject<String>()
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    private let addQuestionObservable = PublishSubject<String>()
    
    let date = BehaviorRelay<Int>(value: 60 * 24)
    let comfirmDate = BehaviorRelay<Int>(value: 60 * 24)
    
    let categories = Observable<[CreateSection]>.of([CreateSection(items: ["공통","인턴","대외활동","디자인","경영기획","회계","생산/품질관리","인사","마케팅","영업","IT/개발","연구개발(R&D)"])])
    
    
    func transform(input: Input) -> Output {
        
        let isValid = Observable.combineLatest(input.question, input.category).map { text, category in
            return !text.isEmpty && text != "면접자 분들은 나에게 어떤 질문을 줄까요?" && category != -1 }
        
        input.question.bind(to: textFieldContentObservable).disposed(by: disposeBag)
        
        input.returnTrigger.withLatestFrom(textFieldContentObservable)
            .bind(to: addQuestionObservable)
            .disposed(by: disposeBag)

        
        self.comfirmDate.bind(to: date).disposed(by: disposeBag)
        
        return Output(isValid: isValid,
                       failMessage: failMessage.asSignal(),
                       successMessage: successMessage.asSignal(),
                       comfirmDate: comfirmDate.asObservable())
            
    }
}


