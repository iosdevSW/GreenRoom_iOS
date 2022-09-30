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
    
    private let myListService: MyListService
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
    private let regiteredKeywordObservable = BehaviorRelay<[String]>(value: [])
    
    private let id: Int
    
    init(id: Int, keywords: Observable<[String]>, service: MyListService){
        self.id = id
        
        keywords.bind(to: regiteredKeywordObservable).disposed(by: disposeBag)
        self.myListService = service
    }
    
    func transform(input: Input) -> Output {
        input.inputKeyword.bind(to: textFieldContentObservable).disposed(by: disposeBag)
        
        input.trigger.withLatestFrom(textFieldContentObservable)
            .bind(to: addKeywordObservable)
            .disposed(by: disposeBag)
        
        addKeywordObservable.subscribe(onNext: { [weak self] keyword in
            guard let self = self else { return }
            
            self.myListService.updateKeywords(id: self.id, keywords: self.regiteredKeywordObservable.value + [keyword]) { isSuccess in
                if isSuccess {
                    self.regiteredKeywordObservable.accept(self.regiteredKeywordObservable.value + [keyword])
                }
            }
            
        }).disposed(by: disposeBag)
        
        return Output(registeredKeywords: self.regiteredKeywordObservable.asObservable())
    }
    
}
