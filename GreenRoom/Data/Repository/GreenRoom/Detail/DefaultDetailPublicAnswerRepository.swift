//
//  DetailPublicAnswerRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import UIKit
import RxSwift

/** 그린룸 질문에 담긴 답변들 중 하나를 클릭했을 때 */
protocol DetailPublicAnswerRepository {
    func fetchDetailAnswer(id: Int) -> Observable<SpecificPublicAnswer>
}

final class DefaultDetailPublicAnswerRepository: DetailPublicAnswerRepository {
    func fetchDetailAnswer(id: Int) -> Observable<SpecificPublicAnswer> {
        let request = GreenRoomRequest.detailAnswer(id: id)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: SpecificPublicAnswer.self, decoder: JSONDecoder())
    }
    
}
