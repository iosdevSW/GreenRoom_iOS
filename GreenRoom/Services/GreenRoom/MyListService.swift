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

struct MyListWithAnswer: Codable {
    let id: Int
    let groupCategoryName, categoryName, question, answer: String
    let keywords: [String]
}

final class MyListService {
    
    func fetchMyQuestionList(completion:@escaping ((Result<[MyQuestion],Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseURL)/api/my-questions")!
        
        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [MyQuestion].self) { response in
                switch response.result {
                    
                case .success(let myQuestions):
                    completion(.success(myQuestions))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func fetchMyQuestion(id: Int) -> Observable<MyListWithAnswer> {
        let url = URL(string: "\(Constants.baseURL)/api/my-questions/\(id)")!

        return Observable.create { emitter in
            AF.request(url, encoding: JSONEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: MyListWithAnswer.self) { response in
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
//    func fetchMyQuestion(id: Int, completion:@escaping((Result<MyListWithAnswer, Error>) -> Void)) {
//        let url = URL(string: "\(Constants.baseURL)/api/my-questions/\(id)")!
//
//        AF.request(url, encoding: JSONEncoding.default, interceptor: AuthManager())
//            .validate(statusCode: 200..<300)
//            .responseString { response in
//                print(response)
//
//                switch response.result {
//                case .success(let result):
//                    print(result)
//                case .failure(let error):
//                    print(error)
//                }
//
//            }
//    }
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
