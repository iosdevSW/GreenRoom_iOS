//
//  ApplyPublicAnswerRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import RxSwift

/** 그린룸 질문 답변 생성*/
protocol ApplyPublicAnswerRepositoryInterface {
    func applyAnswer(id: Int, answer: String, keywords: [String]) -> Observable<Bool>
}

final class ApplyPublicAnswerRepository: ApplyPublicAnswerRepositoryInterface {
    func applyAnswer(id: Int, answer: String, keywords: [String]) -> Observable<Bool> {
        let request = GreenRoomRequest.applyAnswer(id: id, answer: answer, keywords: keywords)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
}
