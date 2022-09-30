//
//  ScrabViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/16.
//

import Foundation
import RxSwift

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
    
    private let recent = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    
    let selectedIndexesObservable = BehaviorSubject<[Int]>(value: [])
    
    var selectedIndexes: [Int] = [] { 
        didSet {
            self.selectedIndexesObservable.onNext(self.selectedIndexes)
        }
    }
    
    func transform(input: Input) -> Output {
        let output = input.trigger.flatMap { _ -> Observable<[PublicQuestion]> in
            return self.scrapService.fetchScrapQuestions()
        }.map {
            return [ScrapSectionModel(items: $0)]
        }
//
//        subscribe(onNext: { [weak self] _ in
//            guard let self = self else { return }
//            self.fetchRecent()
//        }).disposed(by: disposeBag)
        
        input.buttonTab.subscribe(onNext: {
//            selectedIndex해당하는 것들 모두 삭제.
        }).disposed(by: disposeBag)
        
        return Output(scrap: output)
    }
    
}
