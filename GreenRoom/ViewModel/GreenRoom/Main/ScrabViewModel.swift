//
//  ScrabViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/16.
//

import Foundation
import RxSwift
import RxRelay

final class ScrapViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private let scrapService = ScrapService()
    
    struct Input {
        let trigger: Observable<Bool>
        let buttonTab: Observable<Void>
    }
    
    struct Output {
        let scrap: Observable<[ScrapSectionModel]>
    }

    let selectedIndexesObservable = BehaviorRelay<[Int]>(value: [])
    let cancelIndexObservable = PublishSubject<Int>()
    
    private let scrapObesrvable = BehaviorSubject<[ScrapSectionModel]>(value: [])
    

    func transform(input: Input) -> Output {
        
        input.trigger
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.scrapService.fetchScrapQuestions()
            }.map { [ScrapSectionModel(items: $0)] }
            .bind(to: scrapObesrvable)
            .disposed(by: disposeBag)

        cancelIndexObservable
            .withUnretained(self)
            .subscribe(onNext: { onwer, removeID in
            let values = onwer.selectedIndexesObservable.value.filter { removeID != $0 }
            onwer.selectedIndexesObservable.accept(values)
        }).disposed(by: disposeBag)
        
        input.buttonTab
            .withLatestFrom(selectedIndexesObservable.asObservable())
            .withUnretained(self)
            .flatMap { onwer, index in
                onwer.scrapService.deleteScrapQuestion(ids: index)
            }
            .withUnretained(self)
            .flatMap { onwer, index in
                onwer.scrapService.fetchScrapQuestions()
            }
            .map { [ScrapSectionModel(items: $0)] }
            .bind(to: scrapObesrvable)
            .disposed(by: disposeBag)

        return Output(scrap: scrapObesrvable.asObservable())
    }
    
}
