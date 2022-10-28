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
        let trigger: Observable<Void>
        let searchBar: Observable<String>
        let buttonTrigger: Observable<Void>
        let keywordTrigger: Observable<SearchTagItem>
    }
    
    struct Output {
        let searchedKeyword: Observable<[SearchSectionModel]>
        let searchResult: Observable<[FilteringQuestion]>
    }
    
    private let searchResult = PublishSubject<[FilteringQuestion]>()
    
    func transform(input: Input) -> Output {
        
        let searchedKeyword = input.trigger
            .withUnretained(self)
            .flatMap { onwer, _ in
                return Observable.zip(onwer.searchService.fetchPopularKeywords().map { keywords in
                    return [SearchSectionModel.popular(header: "인기 검색어",items: keywords.map { SearchSectionModel.Item(text: $0, type: .popular) })]
                }, onwer.fetchRecentKeywords())
            }.map { $0.0 + $0.1 }
        
        input.buttonTrigger
            .withLatestFrom(input.searchBar)
            .withUnretained(self)
            .flatMap { onwer, keyword in
                onwer.searchService.searchGreenRoomQuestion(keyword: keyword)
            }
            .bind(to: searchResult)
            .disposed(by: disposeBag)
        
        input.keywordTrigger
            .withUnretained(self)
            .flatMap { onwer, keyword in
                onwer.searchService.searchGreenRoomQuestion(keyword: keyword.text)
            }
            .bind(to: searchResult)
            .disposed(by: disposeBag)
        
        return Output(searchedKeyword: searchedKeyword,
                      searchResult: searchResult.asObservable())
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
