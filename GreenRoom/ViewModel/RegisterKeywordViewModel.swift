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
    private let regiteredKeywordObservable = BehaviorRelay<[String]>(value: ["하나","둘","셋"])
    
    func transform(input: Input) -> Output {
        input.inputKeyword.bind(to: textFieldContentObservable).disposed(by: disposeBag)
        
        input.trigger.withLatestFrom(textFieldContentObservable)
            .bind(to: addKeywordObservable)
            .disposed(by: disposeBag)
        
        addKeywordObservable.subscribe(onNext: { [weak self] keyword in
            guard let self = self else { return }
            self.regiteredKeywordObservable.accept(self.regiteredKeywordObservable.value + [keyword])
        }).disposed(by: disposeBag)
        
        return Output(registeredKeywords: self.regiteredKeywordObservable.asObservable())
    }
    
}
