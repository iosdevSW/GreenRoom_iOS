//
//  MyQuestionService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import Foundation
import RxSwift
import Alamofire

final class PublicQuestionService {
    
    private let baseURL = Constants.baseURL + "/api/green-questions"
    
//    func fetchFilteredQuestion(categoryId: Int, completion:@escaping ((Result<[DetailQuestion],Error>) -> Void)) {
//
//        let url = URL(string: "\(Constants.baseURL)/api/green-questions?categoryId=\(categoryId)")!
//
//        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
//            .validate(statusCode: 200..<300)
//            .responseDecodable(of: [DetailQuestion].self) { response in
//            switch response.result {
//
//            case .success(let detailQuestions):
//                completion(.success(detailQuestions))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func fetchRecentPublicQuestions() -> Observable<[PublicQuestion]>{
        let requestURL = baseURL + "/recent-questions"
        
        return Observable.create { emmiter in
            AF.request(requestURL, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [PublicQuestion].self) { response in
                    
                switch response.result {
                case .success(let questions):
                    print(questions)
                    emmiter.onNext(questions)
                case .failure(let error):
                    emmiter.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
    
    func fetchPopularPublicQuestions() -> Observable<[PopularPublicQuestion]>{
        
        let requestURL = baseURL + "/popular-questions"
        
        return Observable.create { emmiter in
            AF.request(requestURL, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [PopularPublicQuestion].self) { response in
                    
                switch response.result {
                case .success(let questions):
                    emmiter.onNext(questions)
                case .failure(let error):
                    emmiter.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
    
    func uploadQuestionList(categoryId: Int, question: String, expiredAt: String) -> Observable<Bool> {
        
        let parameters = UploadPublicQuestionModel(categoryId: categoryId,
                                                   question: question,
                                                   expiredAt: expiredAt)
        
        return Observable.create { emitter in
            AF.request(self.baseURL, method: .post, parameters: parameters, encoder: .json, interceptor: AuthManager()).responseString { response in
                
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
