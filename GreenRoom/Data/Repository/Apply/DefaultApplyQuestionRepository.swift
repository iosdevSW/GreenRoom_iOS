//
//  DefaultApplyQuestionRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import RxSwift

/** 질문 생성*/
protocol ApplyQuestionRepository {
    /** 그린룸 질문 생성*/
    func applyPublicQuestion(categoryId: Int, question: String, expiredAt: String) -> Observable<Bool>
    /** 개인 질문 생성 */
    func applyPrivateQuestion(cateogryId: Int, question: String) -> Observable<Bool>
}

final class DefaultApplyQuestionRepository: ApplyQuestionRepository {
    func applyPrivateQuestion(cateogryId: Int, question: String) -> Observable<Bool> {
        let request = PrivateQuestionRequest.applyQuestion(categoryId: cateogryId, question: question)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func applyPublicQuestion(categoryId: Int, question: String, expiredAt: String) -> Observable<Bool> {
        let request = GreenRoomRequest.applyQuestion(categoryId: categoryId, question: question, expiredAt: expiredAt)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
}
