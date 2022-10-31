//
//  MakePublicAnswerViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/04.
//
import Foundation
import RxSwift
import RxCocoa

final class MakePublicAnswerViewModel: ViewModelType {
    
    var publicQuestionService: PublicQuestionService
    
    var disposeBag = DisposeBag()
    
    var placeholder: String {
        return  """
                나와 같은 동료들은 어떤 답변을 줄까요?
                *부적절한 멘트 사용 혹은 질문과 관련없는 답변은 삼가해주세요.
                (그외의 내용은 자유롭게 기입해주세요)
                *답변 가이드라인은 마이페이지>FAQ를 참고해주세요.
                """
    }
    
    struct Input {
        let text: Observable<String>
        let endEditingTrigger: Observable<Void>
        let keywords: Observable<[String]>
        let doneButtonTrigger: Observable<Void>
    }
    
    struct Output {
        let question: Observable<PublicAnswerSectionModel>
        let successMessage: Signal<String>
        let failMessage: Signal<String>
    }
    
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let answer: PublicAnswerSectionModel
    
    init(answer: PublicAnswerSectionModel, publicQuestionService: PublicQuestionService){
        self.answer = answer
        self.publicQuestionService = publicQuestionService
    }
    
    func transform(input: Input) -> Output {
        
        input.endEditingTrigger.withLatestFrom(input.text)
            .bind(to: textFieldContentObservable).disposed(by: disposeBag)
        
        input.doneButtonTrigger.withLatestFrom(
            Observable.combineLatest(
                textFieldContentObservable.asObserver(),
                input.keywords.asObservable())
        )
        .withUnretained(self)
        .flatMap { onwer, element in
            let (answer, keywords) = element
            return onwer.publicQuestionService.uploadAnswer(id: onwer.answer.header.id, answer: answer, keywords: keywords)
        }
        .withUnretained(self)
        .subscribe(onNext: { onwer, isSuccess in
            isSuccess ? onwer.successMessage.accept("답변 작성이 완료되었습니다.") : onwer.failMessage.accept("글자수는 500자를 초과할 수 없습니다.")
        }).disposed(by: disposeBag)
        
        return Output(question: Observable.just(answer),
                      successMessage: successMessage.asSignal(),
                      failMessage: failMessage.asSignal())
    }
}
