//
//  DetailGreenRoomRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import RxSwift
import Alamofire

/** 그린룸 질문을 클릭했을 때 보이는*/
protocol DetailGreenRoomRepository {
    /** 그린룸질문 상세정보 조회 */
    func fetchDetailPublicQuestion(id: Int) -> Observable<PublicAnswerList>
}

final class DefaultDetailGreenRoomRepository: DetailGreenRoomRepository {

    func fetchDetailPublicQuestion(id: Int) -> Observable<PublicAnswerList> {
        let request = GreenRoomRequest.detailQuestion(id: id)

        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: DetailPublicQuestionDTO.self, decoder: JSONDecoder())
            .flatMap { question in
                let unvisible = [
                    PublicAnswer(id: 0, profileImage: "", answer: ""),
                    PublicAnswer(id: 0, profileImage: "", answer: ""),
                    PublicAnswer(id: 0, profileImage: "", answer: ""),
                    PublicAnswer(id: 0, profileImage: "", answer: "")
                ]

                return self.fetchDetailAnswers(id: question.id).map { answers in
                    return PublicAnswerList(question: question, answers: question.participated && question.expired ? answers : unvisible)
                }
            }
    }

    private func fetchDetailAnswers(id: Int) -> Observable<[PublicAnswer]> {
        let request = GreenRoomRequest.detailAnswers(id: id)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [PublicAnswer].self, decoder: JSONDecoder())
            .catchAndReturn([])

    }
}
