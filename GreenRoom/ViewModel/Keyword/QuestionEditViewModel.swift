//
//  QuestionEditViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/10/10.
//

import Foundation
import RxSwift
import RxCocoa

final class QuestionEditViewModel: ViewModelType {
    
    private let repository: PrivateAnswerRepository
    
    var disposeBag = DisposeBag()
    
    var placeholder: String {
        return  """
                답변을 입력해주세요.
                """
    }
    
    struct Input {
        let text: Observable<String>
        let endEditingTrigger: Observable<Void>
        let keywords: Observable<[String]>
        let deleteButtonTrigger: Observable<Bool>
        let doneButtonTrigger: Observable<Void>
    }
    
    struct Output {
        let answer: Observable<GroupQuestionInfo>
        let keywords: Observable<[String]>
        let successMessage: Signal<String>
        let failMessage: Signal<String>
    }
    
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let id: Int
    
    init(id: Int, repository: PrivateAnswerRepository){
        self.id = id
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        
        input.endEditingTrigger.withLatestFrom(input.text)
            .bind(to: textFieldContentObservable)
            .disposed(by: disposeBag)
        
        input.doneButtonTrigger
            .withLatestFrom(
                Observable.combineLatest(
                    textFieldContentObservable.asObserver(), input.keywords.asObservable()
                )
            )
            .withUnretained(self)
            .flatMap { onwer, element  in
                let (answer, keywords) = element
                return KPQuestionService().uploadAnswer(id: onwer.id, answer: answer, keywords: keywords)
            }
            .withUnretained(self)
            .subscribe(onNext: { onwer, isSuccess in
                isSuccess ? onwer.successMessage.accept("답변 작성이 완료되었습니다.") : onwer.failMessage.accept("글자수는 500자를 초과할 수 없습니다.")
            }).disposed(by: disposeBag)
        
        input.deleteButtonTrigger
            .asObservable()
            .withUnretained(self)
            .flatMap { onwer, _ in
                onwer.repository.deleteQuestion(id: onwer.id)
            }
            .withUnretained(self)
            .subscribe { onwer, competable in
            competable ? onwer.successMessage.accept("질문이 삭제되었습니다.") : onwer.failMessage.accept("에러욤")
        }.disposed(by: disposeBag)
        
        let output = KPQuestionService().fetchGroupQuestion(id: self.id) // api 나오면 다시 적용해야함
        
        return Output(answer: output.asObservable(),
                      keywords: output.map { $0.keywords },
                      successMessage: successMessage.asSignal(),
                      failMessage: failMessage.asSignal())
    }
    
}
