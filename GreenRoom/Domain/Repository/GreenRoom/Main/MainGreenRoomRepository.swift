//
//  MainGreenRoomRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import RxSwift
import Alamofire

protocol MainGreenRoomRepositoryInferface {
    /** 인기있는 그린룸 질문 조회*/
    func fetchPopularPublicQuestions() -> Observable<[PopularGreenRoomQuestion]>
    /** 최근 그린룸 질문 조회*/
    func fetchRecentPublicQuestions() -> Observable<[GreenRoomQuestion]>
    /** 내가 생성한 그린룸 질문 */
    func fetchOwnedPublicQuestions(page: Int) -> Observable<MyGreenRoomQuestion>
    /** 내가 생성한 개인 질문*/
    func fetchPrivateQuestions() -> Observable<[PrivateQuestion]>
}

final class MainGreenRoomRepositry: MainGreenRoomRepositoryInferface {
    
    func fetchFilteringPublicQuestions(categoryId: Int) -> Observable<[FilteringQuestion]> {
        let request = GreenRoomRequest.filtering(categoryId: categoryId)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [FilteringQuestion].self, decoder: JSONDecoder())
            .catchAndReturn([])
    }
    
    func fetchPopularPublicQuestions() -> Observable<[PopularGreenRoomQuestion]> {
        let request = GreenRoomRequest.popular
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [PopularGreenRoomQuestion].self, decoder: JSONDecoder())
            .catchAndReturn([])
    }
    
    func fetchRecentPublicQuestions() -> Observable<[GreenRoomQuestion]> {
        let request = GreenRoomRequest.recent
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [GreenRoomQuestion].self, decoder: JSONDecoder())
            .catchAndReturn([])
    }
    
    func fetchOwnedPublicQuestions(page: Int) -> Observable<MyGreenRoomQuestion> {
        let request = GreenRoomRequest.owned(page: page)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: MyGreenRoomQuestion.self, decoder: JSONDecoder())
            .catchAndReturn(MyGreenRoomQuestion(id: nil, participants: 0, question: nil, profileImages: nil, existed: false, hasPrev: false, hasNext: false))
    }
    
    func fetchPrivateQuestions() -> Observable<[PrivateQuestion]> {
        let request = PrivateQuestionRequest.owned
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [PrivateQuestion].self, decoder: JSONDecoder())
            .catchAndReturn([])
    }
}
