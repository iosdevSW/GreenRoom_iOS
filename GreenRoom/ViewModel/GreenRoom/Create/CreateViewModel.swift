//
//  CreateViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

final class CreateViewModel: ViewModelType {
    
    let questionService = MyQuestionService()
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let question: Observable<String>
        let category: Observable<Int>
        let returnTrigger: Observable<Void>
        let submit: Observable<Void>
    }
    
    struct Output {
        let isValid: Observable<Bool>
        let failMessage: Signal<String>
        let successMessage: Signal<String>
    }
    
    private let tempQuestion = PublishSubject<String>()
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    private let addQuestionObservable = PublishSubject<String>()
    
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let categories = Observable.of(["공통","인턴","대외활동","디자인","경영기획","회계","생산/품질관리","인사","마케팅","영업","IT/개발","연구개발(R&D)"])
    
    func transform(input: Input) -> Output {
        
        input.question.bind(to: textFieldContentObservable).disposed(by: disposeBag)
        
        input.returnTrigger.withLatestFrom(textFieldContentObservable)
            .bind(to: addQuestionObservable)
            .disposed(by: disposeBag)
        
        input.submit.withLatestFrom(Observable.zip(addQuestionObservable.asObserver(), input.category.map { String($0) }))
            .flatMapLatest { (question, category) -> Observable<Bool> in
                print(question)
                return self.questionService.uploadQuestionList(categoryId: Int(category)!, question: question)
            }.subscribe { _ in
                self.successMessage.accept("질문 작성이 완료되었어요!")
            } onError: { error in
                self.failMessage.accept(error.localizedDescription)
            }.disposed(by: disposeBag)

        return Output(isValid:
                        Observable.combineLatest(input.question, input.category).map { text, category in
            return !text.isEmpty && text != "면접자 분들은 나에게 어떤 질문을 줄까요?" && category != -1 },
                      failMessage: failMessage.asSignal(), successMessage: successMessage.asSignal())
            
    }

}
