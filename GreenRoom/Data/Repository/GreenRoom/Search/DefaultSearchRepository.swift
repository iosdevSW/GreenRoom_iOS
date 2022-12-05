//
//  SearchRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import RxSwift
import Alamofire

protocol SearchRepository {
    func fetchPopularKeywords() -> Observable<[String]>
    func fetchRecentKeywords() -> [String]
    func searchQuestion(keyword: String) -> Observable<[FilteringQuestion]>
}

final class DefaultSearchRepository: SearchRepository {

    func fetchPopularKeywords() -> Observable<[String]>{
        let request = SearchRequest.popular
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [String].self, decoder: JSONDecoder())
            .catchAndReturn([])
    }

    func searchQuestion(keyword: String) -> Observable<[FilteringQuestion]> {
        let request = SearchRequest.question(text: keyword)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [FilteringQuestion].self, decoder: JSONDecoder())
    }
    
    func fetchRecentKeywords() -> [String] {
        return CoreDataManager.shared.loadFromCoreData(request: RecentSearchKeyword.fetchRequest())
                .sorted { $0.date! > $1.date! }
                .prefix(10)
                .compactMap({ keyword in
                    keyword.keyword
                })
               
    }
}
