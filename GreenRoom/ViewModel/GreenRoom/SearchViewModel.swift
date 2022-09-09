//
//  SearchViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/09.
//

import Foundation
import RxSwift

final class SearchViewModel: ViewModelType {
    
    let greenroomService = GreenRoomService()
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Observable<Void>
    }
    
    struct Output {
        let result: Observable<[GRSearchModel]>
    }
    
    var recentKeywords = BehaviorSubject<[GRSearchModel]>(value: [
        GRSearchModel.recent(header: "최근 검색어",items: [])
    ])
    
    var popularKeywords = BehaviorSubject<[GRSearchModel]>(value: [
        GRSearchModel.recent(header: "인기 검색어",items: [])
    ])
    
    func transform(input: Input) -> Output {
        input.trigger.subscribe(onNext: {
            self.fetchKeywords()
        }).disposed(by: disposeBag)
        
        let keywords = Observable.combineLatest(recentKeywords.asObserver(), popularKeywords.asObserver()).map { $0.0 + $0.1
        }
        
        return Output(result: keywords)
    }
    
    private func fetchKeywords() {
        recentKeywords.onNext(
            [GRSearchModel.recent(header: "최근 검색어", items:
                                    CoreDataManager.shared.loadFromCoreData(request: RecentSearchKeyword.fetchRequest()).sorted {
                                        $0.date! > $1.date!
                                    }.map {
                                        SearchTagItem(text: $0.keyword!, type: .recent)
                                    })
            ]
        )
        
        
        greenroomService.fetchPopularKeywords { [weak self] result in
            switch result {
            case .success(let keywords):
                self?.popularKeywords.onNext(
                    [GRSearchModel.popular(header: "인기 검색어", items:
                                            keywords.map {
                                                GRSearchModel.Item(text: $0, type: .popular)
                                            })
                    ]
                )
            case .failure(_):
                break
            }
        }
    }
    
}
