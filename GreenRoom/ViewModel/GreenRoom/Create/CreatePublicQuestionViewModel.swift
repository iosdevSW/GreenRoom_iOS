//
//  CreateGRViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/17.
//

import Foundation
import RxSwift
import RxCocoa


final class CreatePublicQuestionViewModel: ViewModelType {
    
    private let publicQuestionService = PublicQuestionService()
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let date: Observable<Date>
        let dateApplyTrigger: Observable<Void>
        let question: Observable<String>
        let category: Observable<Int>
        let returnTrigger: Observable<Void>
        let submit: Observable<Void>
    }
    
    struct Output {
        let date: Observable<Int>
        let isValid: Observable<Bool>
        let failMessage: Signal<String>
        let successMessage: Signal<String>
        let comfirmDate: Observable<Int>
    }
    
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    private let addQuestionObservable = PublishSubject<String>()
    
    private let date = BehaviorRelay<Int>(value: 60 * 24)
    private let confirmDate = BehaviorRelay<Int>(value: 60 * 24)
    
    let categories = Observable<[CreateSection]>.of([CreateSection(items: Constants.categories)])
    
    
    func transform(input: Input) -> Output {
        
        input.question.bind(to: textFieldContentObservable).disposed(by: disposeBag)
        
        input.returnTrigger.withLatestFrom(textFieldContentObservable)
            .bind(to: addQuestionObservable)
            .disposed(by: disposeBag)
        
        input.dateApplyTrigger.withLatestFrom(input.date.asObservable())
            .map { $0.getMinutes() }
            .bind(to: self.confirmDate)
            .disposed(by: disposeBag)

        input.submit.withLatestFrom(
            Observable.combineLatest(
                input.category.asObservable(),
                addQuestionObservable.asObservable(),
                confirmDate.asObservable()
            )
        ).flatMap { (categoryId, question, minutes) -> Observable<Bool> in
            self.publicQuestionService.uploadQuestionList(categoryId: categoryId,
                                                           question: question,
                                                          expiredAt: self.getExpiredDate(minutes: minutes))
        }.subscribe { _ in
            self.successMessage.accept("질문 작성이 완료되었어요!")
        } onError: { error in
            self.failMessage.accept(error.localizedDescription)
        }.disposed(by: disposeBag)
        
        let isValid = Observable.combineLatest(input.question, input.category).map { text, category in
            return !text.isEmpty && text != "면접자 분들은 나에게 어떤 질문을 줄까요?" && category != -1 }
        
        return Output(date: date.asObservable(),
                      isValid: isValid,
                       failMessage: failMessage.asSignal(),
                       successMessage: successMessage.asSignal(),
                       comfirmDate: confirmDate.asObservable())
            
    }
    
    private func getExpiredDate(minutes: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter.string(from: Date().adding(minutes: minutes))
    }
}


