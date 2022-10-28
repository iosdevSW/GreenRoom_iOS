//
//  RegisterKeywordViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/25.
//

import Foundation
import RxSwift
import RxCocoa

final class RegisterKeywordViewModel: ViewModelType {
    
    let publicService = PublicQuestionService()
    let privateService = PrivateQuestionService()
    let kpQuestionService = KPQuestionService()
    var disposeBag = DisposeBag()
      
    struct Input {
        let inputKeyword: Observable<String>
        let trigger: Observable<Void>
    }
    
    struct Output {
        let registeredKeywords: Observable<[String]>
    }
    
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    private let addKeywordObservable = PublishSubject<String>()
    private let registeredKeywordObservable = BehaviorRelay<[String]>(value: [])
    
    private let id: Int
    private let answerType: AnswerType
    
    init(id: Int, answerType: AnswerType){
        self.id = id
        self.answerType = answerType
    }
    
    func transform(input: Input) -> Output {
        
        
        switch answerType {
        case .public:
            break
        case .private:
            self.privateService.fetchPrivateQuestion(id: id)
                .map { $0.keywords }
                .bind(to: registeredKeywordObservable)
                .disposed(by: disposeBag)
        case .kpQuestion:
            self.kpQuestionService.fetchGroupQuestion(id: id)
                .map { $0.keywords }
                .bind(to: registeredKeywordObservable)
                .disposed(by: disposeBag)
        }
        
        input.inputKeyword
            .bind(to: textFieldContentObservable)
            .disposed(by: disposeBag)
        
        input.trigger
            .withLatestFrom(textFieldContentObservable)
            .bind(to: addKeywordObservable)
            .disposed(by: disposeBag)
        
        addKeywordObservable
            .withUnretained(self)
            .subscribe(onNext: { onwer, keyword in
                onwer.registeredKeywordObservable
                    .accept(onwer.registeredKeywordObservable.value + [keyword])
        }).disposed(by: disposeBag)
        
        return Output(registeredKeywords: self.registeredKeywordObservable.asObservable())
    }
    
}
