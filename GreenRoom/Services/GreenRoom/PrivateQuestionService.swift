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
    case notAuthorization
    case unKnownError
    
    public var errorDescription: String? {
        switch self {
        case .exceedMaximumLength:
            return NSLocalizedString("질문의 길이는 50자 이하여야 합니다.", comment: "exceedMaximumLength")
        case .invalidCategory:
            return NSLocalizedString("지원하는 카테고리가 아닙니다", comment: "invalidCategory")
        case .notAuthorization:
            return NSLocalizedString("해당 질문을 삭제할 수 없습니다", comment: "notAuthorization")
        case .unKnownError:
            return NSLocalizedString("알 수 없는 에러가 발생했습니다.", comment: "unKnownError")
        }
    }
}


final class PrivateQuestionService {
    
    private var baseURL = "\(Constants.baseURL)/api/my-questions"

    /** 나의 질문 생성 API */
    func uploadQuestion(categoryId: Int, question: String) -> Observable<Bool> {
        
        let requestURL = self.baseURL
        
        let parameters: Parameters = [
            "categoryId": categoryId,
            "question": question
        ]
        
        return Observable.create { emitter in
            AF.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, interceptor: AuthManager()).responseData { response in
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
    
    func updateQuestion(id: Int, categoryId: Int, question: String) -> Observable<Bool> {
        let requestURL = self.baseURL + "/\(id)"
        
        let parameters: Parameters = [
            "id": id,
            "categoryId": categoryId,
            "question": question
        ]
        
        return Observable.create { emitter in
            AF.request(requestURL, method: .put, parameters: parameters, encoding: JSONEncoding.default, interceptor: AuthManager()).responseData { response in
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
    
    /** 내가 작성한 질문 리스트 조회*/
    func fetchPrivateQuestions() -> Observable<[PrivateQuestion]> {
        
        return Observable.create { emitter in
            AF.request(self.baseURL, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
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
    
    /** 내가 작성한 특정 질문에 대한 답변과 키워드 조회*/
    func fetchPrivateQuestion(id: Int) -> Observable<PrivateAnswer> {
        
        let requestURL = baseURL + "/\(id)"
        
        return Observable.create { emitter in
            
            AF.request(requestURL, encoding: JSONEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: PrivateAnswer.self) { response in
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
    
    func uploadKeywords(id: Int, keywords: [String]) -> Observable<Bool> {
        
        let paramaters: Parameters = ["keywords": keywords]
        let requestURL = baseURL + "/answer/\(id)"
        
        return Observable.create { emitter in
            
            AF.request(requestURL, parameters: paramaters, encoding: JSONEncoding.default, interceptor: AuthManager())
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
    
    /** 내가 작성한 질문(id)에 대한 답변 수정*/
    func uploadAnswer(id: Int, answer: String, keywords: [String]) -> Observable<Bool> {
        
        var parameters: Parameters?
       
        if answer != "" || keywords != [] { parameters = Parameters() }
        if answer != "" { parameters?["answer"] = answer }
        if keywords != [] { parameters?["keywords"] = keywords }
        
        let reuqestURL = baseURL + "/answer/\(id)"
        
        return Observable.create { emitter in

            
            AF.request(reuqestURL, method: .put, parameters: parameters, encoding: JSONEncoding.default, interceptor: AuthManager())
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
    
    /** 내가 작성한 질문(id)을 삭제*/
    func removeAnswer(id: Int) -> Observable<Bool> {
        
        let requestURL = baseURL + "/\(id)"
        
        return Observable.create { emitter in
            AF.request(requestURL, method: .delete, interceptor: AuthManager())
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
}
