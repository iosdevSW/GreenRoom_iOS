//
//  SearchViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/09.
//

import Foundation
import RxSwift

final class SearchViewModel: ViewModelType {
    
    private let searchService = SearchService()
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let result: Observable<[SearchSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        
        let output = input.trigger
            .flatMap { _ in
                return Observable.zip(self.searchService.fetchPopularKeywords().map { keywords in
                    return [SearchSectionModel.popular(header: "인기 검색어",items: keywords.map { SearchSectionModel.Item(text: $0, type: .popular) })]
                }, self.fetchRecentKeywords())
            }.map { $0.0 + $0.1 }
            
        
        return Output(result: output)
    }
    
    private func fetchRecentKeywords() -> Observable<[SearchSectionModel]> {
        return Observable.of([
            SearchSectionModel.recent(
                header: "최근 검색어",
                items: CoreDataManager.shared.loadFromCoreData(request: RecentSearchKeyword.fetchRequest())
                    .sorted { $0.date! > $1.date! }
                    .map { SearchTagItem(text: $0.keyword!, type: .recent) })
        ])
    }
}
