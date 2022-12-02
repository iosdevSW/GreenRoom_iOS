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
    
    let kpQuestionService = KPQuestionService()
    private let repository: RegisterKeywordRepository
    var disposeBag = DisposeBag()
      
    struct Input {
        let inputKeyword: Observable<String>
        let trigger: Observable<Void>
        let removeKeyword: Observable<IndexPath>
    }
    
    struct Output {
        let registeredKeywords: Observable<[String]>
    }
    
    private let registeredKeywordObservable = BehaviorRelay<[String]>(value: [])
    
    private let id: Int
    private let answerType: AnswerType
    
    init(id: Int, answerType: AnswerType, repository: RegisterKeywordRepository){
        self.id = id
        self.answerType = answerType
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        
        switch answerType {
        case .public:
            break
        case .private:
            self.repository.fetchPrivateQuestion(id: id)
                .map { $0.keywords }
                .bind(to: registeredKeywordObservable)
                .disposed(by: disposeBag)
        case .kpQuestion:
            self.kpQuestionService.fetchGroupQuestion(id: id)
                .map { $0.keywords }
                .bind(to: registeredKeywordObservable)
                .disposed(by: disposeBag)
        }
        
        input.trigger.withLatestFrom(input.inputKeyword.filter { !$0.isEmpty })
            .withUnretained(self)
            .subscribe(onNext: { onwer, keyword in
                onwer.registeredKeywordObservable
                    .accept(onwer.registeredKeywordObservable.value + [keyword])
        }).disposed(by: disposeBag)
        
        input.removeKeyword
            .map { $0.row}
            .withUnretained(self)
            .subscribe(onNext: { (onwer,row) in
                var keywords = onwer.registeredKeywordObservable.value
                keywords.remove(at: row)
                onwer.registeredKeywordObservable.accept(keywords)
            }).disposed(by: disposeBag)
        
        return Output(registeredKeywords: self.registeredKeywordObservable.asObservable())
    }
    
}
