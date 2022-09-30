//
//  AnswerViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/22.
//

import Foundation
import RxSwift
import RxCocoa

final class AnswerViewModel: ViewModelType {
    
    private let myListService = MyListService()
    var disposeBag = DisposeBag()
    
    struct Input {
        let text: Observable<String>
        let buttonTap: Observable<Void>
    }
    
    struct Output {
        let answer: Observable<QuestionWithAnswer>
        let keywords: Observable<[String]>
        let successMessage: Signal<String>
        let failMessage: Signal<String>
    }
    
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let id: Int
    
    init(id: Int){
        self.id = id
    }
    
    func transform(input: Input) -> Output {
        input.text.bind(to: textFieldContentObservable).disposed(by: disposeBag)

        input.buttonTap.withLatestFrom(textFieldContentObservable.asObserver())
            .flatMap { [weak self] answer -> Observable<Bool>  in
                guard let self = self else {
                    return Observable.just(false)
                }
                return self.myListService.uploadAnswer(id: self.id, answer: answer)
            }
            .subscribe(onNext: { [weak self] isSuccess in
                isSuccess ? self?.successMessage.accept("답변 작성이 완료되었습니다.") : self?.failMessage.accept("글자수는 500자를 초과할 수 없습니다.")
            }).disposed(by: disposeBag)
        
        let output = self.myListService.fetchPrivateQuestion(id: self.id)

        return Output(answer: output.asObservable(),
                      keywords: output.map { $0.keywords},
                      successMessage: successMessage.asSignal(),
                      failMessage: failMessage.asSignal())
    }
    
    func getPlaceholder() -> String {
        return  """
                나와 같은 동료들은 어떤 답변을 줄까요?
                *부적절한 멘트 사용 혹은 질문과 관련없는 답변은 삼가해주세요.
                (그외의 내용은 자유롭게 기입해주세요)
                *답변 가이드라인은 마이페이지>FAQ를 참고해주세요.
                """
    }
}
