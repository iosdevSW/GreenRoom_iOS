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
    
    private let date = BehaviorRelay<Int>(value: 60 * 24)
    private let confirmDate = BehaviorRelay<Int>(value: 60 * 24)
    
    let categories: Observable<[CreateSection]> = .of([CreateSection(items: Constants.categories)])
    
    func transform(input: Input) -> Output {
        
        input.dateApplyTrigger
            .withLatestFrom(input.date.asObservable())
            .map { $0.getMinutes() }
            .bind(to: self.confirmDate)
            .disposed(by: disposeBag)
    
        input.submit.withLatestFrom(
            Observable.combineLatest(input.category, input.question, confirmDate)
        )
        .withUnretained(self)
        .flatMap { (owner, element) in
            owner.publicQuestionService.uploadQuestionList(
                categoryId: element.0,
                question: element.1,
                expiredAt: owner.getExpiredDate(minutes: element.2)
            )
        }
        .withUnretained(self)
            .subscribe { onwer, state in
                state ? onwer.successMessage.accept("질문 작성이 완료되었어요!") : onwer.failMessage.accept("글자수는 50자로 제한되어 있습니다.")
            }.disposed(by: disposeBag)
        
        let isValid = Observable.combineLatest(
            input.question, input.category
        ).compactMap { [weak self] text, category in
            self?.checkValidation(text: text, categoryId: category)
        }
        
        return Output(date: date.asObservable(),
                      isValid: isValid,
                      failMessage: failMessage.asSignal(),
                      successMessage: successMessage.asSignal(),
                      comfirmDate: confirmDate.asObservable())
        
    }
}

extension CreatePublicQuestionViewModel {
    private func getExpiredDate(minutes: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        return dateFormatter.string(from: Date().adding(minutes: minutes))
    }
    
    private func checkValidation(text: String, categoryId: Int) -> Bool {
        return !text.isEmpty && text != "면접자 분들은 나에게 어떤 질문을 줄까요?" && categoryId != -1
    }
}
