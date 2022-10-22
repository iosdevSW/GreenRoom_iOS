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
        
        input.trigger.flatMap { _ -> Observable<[GreenRoomQuestion]> in
            return self.scrapService.fetchScrapQuestions()
        }.map { [ScrapSectionModel(items: $0)] }
            .bind(to: scrapObesrvable)
            .disposed(by: disposeBag)

        cancelIndexObservable.subscribe(onNext: { [weak self] removeID in
            guard let values = self?.selectedIndexesObservable.value.filter({
                removeID != $0
            }) else { return }
            self?.selectedIndexesObservable.accept(values)
        }).disposed(by: disposeBag)
        
        input.buttonTab.withLatestFrom(selectedIndexesObservable.asObservable())
            .flatMap { ids in
                return self.scrapService.deleteScrapQuestion(ids: ids)
            }.flatMap { _ -> Observable<[GreenRoomQuestion]> in
                return self.scrapService.fetchScrapQuestions()
            }.map { [ScrapSectionModel(items: $0)] }
                .bind(to: scrapObesrvable)
                .disposed(by: disposeBag)

        return Output(scrap: scrapObesrvable.asObservable())
    }
    
}
