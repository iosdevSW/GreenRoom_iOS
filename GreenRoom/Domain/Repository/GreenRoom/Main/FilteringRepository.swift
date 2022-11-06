//
//  FilteringRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import RxSwift

protocol FilteringRepositoryInterface {
    /** 내가 관심있어 하는 직무에 대한 질문들 조회*/
    func fetchFilteringQuestion(categoryId: Int) -> Observable<[FilteringQuestion]>
    /** 검색 기능으로 조회*/
    func fetchFilteringQuestion(keyword: String) -> Observable<[FilteringQuestion]>
}

final class FilteringRepository: FilteringRepositoryInterface {
    func fetchFilteringQuestion(categoryId: Int) -> Observable<[FilteringQuestion]> {
        let request = GreenRoomRequest.filtering(categoryId: categoryId)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [FilteringQuestion].self, decoder: JSONDecoder())
            .catchAndReturn([])
    }
    
    func fetchFilteringQuestion(keyword: String) -> Observable<[FilteringQuestion]> {
        let request = SearchRequest.question(text: keyword)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [FilteringQuestion].self, decoder: JSONDecoder())
            .catchAndReturn([])
    }
    
}
