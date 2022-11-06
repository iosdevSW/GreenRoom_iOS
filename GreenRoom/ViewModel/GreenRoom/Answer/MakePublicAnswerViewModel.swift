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
    
    private let repository: ApplyPublicAnswerRepositoryInterface
    
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
        let keywords: Observable<[String]>
        let doneButtonTrigger: Observable<Void>
    }
    
    struct Output {
        let question: Observable<PublicAnswerSectionModel>
        let successMessage: Signal<String>
        let failMessage: Signal<String>
    }

    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let answer: PublicAnswerSectionModel
    
    init(answer: PublicAnswerSectionModel, repository: ApplyPublicAnswerRepositoryInterface){
        self.answer = answer
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        
        input.doneButtonTrigger.withLatestFrom(
            Observable.combineLatest(
                input.text,
                input.keywords)
        )
        .withUnretained(self)
        .flatMap { onwer, element in
            let (answer, keywords) = element
            return onwer.repository.applyAnswer(id: onwer.answer.header.id, answer: answer, keywords: keywords)
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
