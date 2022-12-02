//
//  PrivateAnswerRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import RxSwift

protocol PrivateAnswerRepository {
    func fetchPrivateQuestion(id: Int) -> Observable<PrivateAnswer>
    func deleteQuestion(id: Int) -> Observable<Bool>
    func uploadAnswer(id: Int, answer: String, keywords: [String]) -> Observable<Bool>
}

final class DefaultPrivateAnswerRepository: PrivateAnswerRepository {
    func fetchPrivateQuestion(id: Int) -> Observable<PrivateAnswer> {
        let request = PrivateQuestionRequest.fetch(id: id)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: PrivateAnswer.self, decoder: JSONDecoder())
    }
    func deleteQuestion(id: Int) -> Observable<Bool> {
        let request = PrivateQuestionRequest.delete(id: id)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func uploadAnswer(id: Int, answer: String, keywords: [String]) -> Observable<Bool> {
        
        let request: PrivateQuestionRequest
        
        if keywords.isEmpty {
            request = PrivateQuestionRequest.applyAnswer(id: id, answer: answer)
        } else if answer.isEmpty {
            request = PrivateQuestionRequest.applyKeyword(id: id, keywords: keywords)
        } else {
            request = PrivateQuestionRequest.applyAnswerWithKeywords(id: id, answer: answer, keywords: keywords)
        }
        
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
}

