//
//  SearchViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/09.
//

import Foundation
import RxSwift

final class SearchViewModel: ViewModelType {
    
    private let searchRepository: SearchRepository
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Observable<Bool>
        let text: Observable<String>
    }
    
    struct Output {
        let searchedKeyword: Observable<[SearchSectionModel]>
    }
    
    private let updateTrigger = BehaviorSubject<Bool>(value: true)
    
    init(repository: SearchRepository){
        self.searchRepository = repository
    }
    
    func transform(input: Input) -> Output {
        
        input.text
            .flatMap { keyword in
                CoreDataManager.shared.saveRecentSearch(keyword: keyword, date: Date())
            }
            .bind(to: updateTrigger)
            .disposed(by: disposeBag)
        
        let searchedKeyword = input.trigger
            .withUnretained(self)
            .flatMap { owner, _ in
                return Observable.zip(
                    owner.fetchPopularKeyword(),
                    owner.fetchRecentKeywords()
                )}.map { $0.0 + $0.1 }
        
        return Output(searchedKeyword: searchedKeyword)
    }
    
    private func fetchRecentKeywords() -> Observable<[SearchSectionModel]> {
        return Observable.of([
            .recent(header: "최근 검색어",
                    items: searchRepository.fetchRecentKeywords()
                    .map { SearchTagItem(text: $0, type: .recent) })
        ])
    }
    
    private func fetchPopularKeyword() -> Observable<[SearchSectionModel]> {
        
        return searchRepository.fetchPopularKeywords().map { keywords in
            return [SearchSectionModel.popular(header: "인기 검색어",items: keywords.map { SearchSectionModel.Item(text: $0, type: .popular) })]
        }
    }
}
