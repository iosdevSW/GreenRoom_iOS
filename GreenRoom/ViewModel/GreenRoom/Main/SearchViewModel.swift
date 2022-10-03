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
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let result: Observable<[SearchSectionModel]>
    }
    
    private var recentKeywords = BehaviorSubject<[SearchSectionModel]>(value: [
        SearchSectionModel.recent(header: "최근 검색어",items: [])
    ])
    
    private var popularKeywords = BehaviorSubject<[SearchSectionModel]>(value: [
        SearchSectionModel.popular(header: "인기 검색어",items: [])
    ])
    
    func transform(input: Input) -> Output {
        input.trigger.subscribe(onNext: { [weak self] _ in
            self?.fetchKeywords()
        }).disposed(by: disposeBag)
        
        let keywords = Observable.combineLatest(popularKeywords.asObserver(),
                                                recentKeywords.asObserver()).map { $0.0 + $0.1 }
        
        return Output(result: keywords)
    }
    
    private func fetchKeywords() {
        recentKeywords.onNext(
            [
                SearchSectionModel.recent(
                    header: "최근 검색어",
                    items: CoreDataManager.shared.loadFromCoreData(request: RecentSearchKeyword.fetchRequest())
                        .sorted { $0.date! > $1.date! }
                        .map { SearchTagItem(text: $0.keyword!, type: .recent) })
            ]
        )
        
        
        greenroomService.fetchPopularKeywords { [weak self] result in
            switch result {
            case .success(let keywords):
                print("DEBUG: popular")
                self?.popularKeywords.onNext([
                    SearchSectionModel.popular(
                            header: "인기 검색어",
                            items: keywords.map { SearchSectionModel.Item(text: $0, type: .popular) }
                        )]
                )
            case .failure(_):
                break
            }
        }
    }
    
}
