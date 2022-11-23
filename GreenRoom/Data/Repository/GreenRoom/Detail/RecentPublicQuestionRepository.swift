//
//  RecentPublicQuestionRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import RxSwift

/** 최근 그린룸 질문 클릭*/
protocol RecentPublicQuestionRepositoryInterface {
    func fetchRecentPublicQuestions() -> Observable<[GreenRoomQuestion]>
}

final class RecentPublicQuestionRepository: RecentPublicQuestionRepositoryInterface {
    func fetchRecentPublicQuestions() -> Observable<[GreenRoomQuestion]> {
        let request = GreenRoomRequest.recent
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [GreenRoomQuestion].self, decoder: JSONDecoder())
    }
}
