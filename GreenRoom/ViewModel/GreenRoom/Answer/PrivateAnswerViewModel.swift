//
//  AnswerViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/22.
//

import Foundation
import RxSwift
import RxCocoa

final class PrivateAnswerViewModel: ViewModelType {
    
    private let repository: PrivateAnswerRepository
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
        let deleteButtonTrigger: Observable<Bool>
        let doneButtonTrigger: Observable<Void>
    }
    
    struct Output {
        let answer: Observable<PrivateAnswer>
        let keywords: Observable<[String]>
        let successMessage: Signal<String>
        let failMessage: Signal<String>
    }

    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let id: Int
    
    init(id: Int, repository: PrivateAnswerRepository){
        self.id = id
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        
        input.doneButtonTrigger
            .withLatestFrom(Observable.combineLatest(input.text, input.keywords))
            .withUnretained(self)
            .flatMap { owner, element in
                self.repository.uploadAnswer(id: owner.id, answer: element.0, keywords: element.1)
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
                competable ? onwer.successMessage.accept("나의 질문이 삭제되었습니다.") : onwer.failMessage.accept("에러")
            }.disposed(by: disposeBag)
        
        let output = self.repository.fetchPrivateQuestion(id: self.id)
        
        return Output(answer: output.asObservable(),
                      keywords: output.map { $0.keywords },
                      successMessage: successMessage.asSignal(),
                      failMessage: failMessage.asSignal())
    }
    
}
