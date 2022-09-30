//
//  QuestionService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import RxSwift
import RxCocoa


enum QuestionError: Error, LocalizedError {
    case exceedMaximumLength
    case invalidCategory
    
    public var errorDescription: String? {
        switch self {
        case .exceedMaximumLength:
            return NSLocalizedString("질문의 길이는 50자 이하여야 합니다.", comment: "exceedMaximumLength")
        case .invalidCategory:
            return NSLocalizedString("지원하는 카테고리가 아닙니다", comment: "invalidCategory")
        }
    }
}

struct QuestionWithAnswer: Codable {
    let id: Int
    let groupCategoryName, categoryName, question: String
    let answer: String?
    let keywords: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, groupCategoryName, categoryName, question, answer, keywords
    }
}

final class MyListService {
    
    func fetchPrivateQuestions() -> Observable<[PrivateQuestion]> {
        
        let url = URL(string: "\(Constants.baseURL)/api/my-questions")!
        
        return Observable.create { emitter in
            AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [PrivateQuestion].self) { response in
                    switch response.result {
                        
                    case .success(let questions):
                        emitter.onNext(questions)
                    case .failure(let error):
                        emitter.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchPrivateQuestion(id: Int) -> Observable<QuestionWithAnswer> {
        let url = URL(string: "\(Constants.baseURL)/api/my-questions/\(id)")!
        
        return Observable.create { emitter in
            AF.request(url, encoding: JSONEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: QuestionWithAnswer.self) { response in
                    switch response.result {
                    case .success(let answer):
                        emitter.onNext(answer)
                    case .failure(let error):
                        emitter.onError(error)
                    }
                    
                }
            
            return Disposables.create()
        }
    }
    
    func updateKeywords(id: Int, keywords: [String], completion:@escaping((Bool) -> Void)) {
        
        let paramaters: Parameters = [
            "keywords": keywords
        ]
        
        let url = "\(Constants.baseURL)/api/my-questions/answer/\(id)"
        
        AF.request(url, method: .put, parameters: paramaters, encoding: JSONEncoding.default, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(_):
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }
    }
    
    func uploadKeywords(id: Int, keywords: [String]) -> Observable<Bool> {
        
        let paramaters: Parameters = [
            "keywords": keywords
        ]
        
        return Observable.create { emitter in
            
            let url = "\(Constants.baseURL)/api/my-questions/answer/\(id)"
            
            AF.request(url, parameters: paramaters, encoding: JSONEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success(_):
                        emitter.onNext(true)
                    case .failure(_):
                        emitter.onNext(false)
                    }
                }
            return Disposables.create()
        }
    }
    
    func uploadAnswer(id: Int, answer: String) -> Observable<Bool> {
        
        let paramaters: Parameters = [
            "answer": answer
        ]
        
        return Observable.create { emitter in
            
            let url = "\(Constants.baseURL)/api/my-questions/answer/\(id)"
            
            AF.request(url, method: .put, parameters: paramaters, encoding: JSONEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success(_):
                        emitter.onNext(true)
                    case .failure(_):
                        emitter.onNext(false)
                    }
                }
            return Disposables.create()
        }
    } 
    
    func uploadQuestionList(categoryId: Int, question: String) -> Observable<Bool> {
        
        let url = URL(string: "\(Constants.baseURL)/api/my-questions")!
        
        let parameters = UploadQuestionModel(categoryId: categoryId, question: question)
        
        return Observable.create { emitter in
            AF.request(url, method: .post, parameters: parameters, encoder: .json, interceptor: AuthManager()).responseData { response in
                switch response.result {
                case .success(_):
                    if response.response?.statusCode == 400 {
                        emitter.onError(QuestionError.exceedMaximumLength)
                    } else if response.response?.statusCode == 404 {
                        emitter.onError(QuestionError.invalidCategory)
                    } else {
                        emitter.onNext(true)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
}
