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
    
    private let privateQuestionService = PrivateQuestionService()
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
    
    init(id: Int){
        self.id = id
    }
    
    func transform(input: Input) -> Output {
        
        input.endEditingTrigger.withLatestFrom(input.text)
            .bind(to: textFieldContentObservable)
            .disposed(by: disposeBag)
        
        input.doneButtonTrigger.withLatestFrom(Observable.combineLatest(textFieldContentObservable.asObserver(), input.keywords.asObservable()))
            .flatMap { [weak self] answer, keywords -> Observable<Bool>  in
                guard let self = self else {
                    return Observable.just(false)
                }
                
                return KPQuestionService().uploadAnswer(id: self.id, answer: answer, keywords: keywords)
            }
            .subscribe(onNext: { [weak self] isSuccess in
                isSuccess ? self?.successMessage.accept("답변 작성이 완료되었습니다.") : self?.failMessage.accept("글자수는 500자를 초과할 수 없습니다.")
            }).disposed(by: disposeBag)
        
        input.deleteButtonTrigger.asObservable().flatMap { _ in
            self.privateQuestionService.removeAnswer(id: self.id)
        }.subscribe { [weak self] competable in
            competable ? self?.successMessage.accept("질문이 삭제되었습니다.") : self?.failMessage.accept("에러욤")
        }.disposed(by: disposeBag)
        
        let output = KPQuestionService().fetchGroupQuestion(id: self.id) // api 나오면 다시 적용해야함
        
        return Output(answer: output.asObservable(),
                      keywords: output.map { $0.keywords },
                      successMessage: successMessage.asSignal(),
                      failMessage: failMessage.asSignal())
    }
    
}
