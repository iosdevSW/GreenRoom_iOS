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
    
    private let myListService = PrivateQuestionService()
    
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
    
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    private let addQuestionObservable = PublishSubject<String>()
    
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let categories = Observable.of(Constants.categories)
    
    func transform(input: Input) -> Output {
        
        input.question.bind(to: textFieldContentObservable).disposed(by: disposeBag)
        
        input.returnTrigger.withLatestFrom(textFieldContentObservable)
            .bind(to: addQuestionObservable)
            .disposed(by: disposeBag)
        
        input.submit.withLatestFrom(
            Observable.combineLatest(
                addQuestionObservable.asObserver(),
                input.category.map { String($0) }
            )
        )
        .withUnretained(self)
        .flatMapLatest { (owner, element) in
            let (question, category) = element
            return owner.myListService.uploadQuestion(
                categoryId: Int(category)!,
                question: question
            )
        }
        .withUnretained(self)
        .subscribe { onwer, state in
            state ? onwer.successMessage.accept("질문 작성이 완료되었어요!") : self.failMessage.accept("글자수는 50자로 제한되어 있습니다.")
        }.disposed(by: disposeBag)
        
        let valid = Observable.combineLatest(input.question, input.category)
            .compactMap { [weak self] text, category in
                return self?.checkValidation(text: text, categoryId: category)
            }
        
        return Output(isValid: valid,
                      failMessage: failMessage.asSignal(),
                      successMessage: successMessage.asSignal())
        
    }
    
    private func checkValidation(text: String, categoryId: Int) -> Bool {
        return !text.isEmpty && text != "면접자 분들은 나에게 어떤 질문을 줄까요?" && categoryId != -1
    }
    
}
