//
//  MyQuestionService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import Foundation
import RxSwift
import Alamofire

final class GreenRoomQuestionService {
    
    func fetchFilteredQuestion(categoryId: Int, completion:@escaping ((Result<[DetailQuestion],Error>) -> Void)) {
        
        let url = URL(string: "\(Constants.baseURL)/api/green-questions?categoryId=\(categoryId)")!
        
        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [DetailQuestion].self) { response in
            switch response.result {

            case .success(let detailQuestions):
                completion(.success(detailQuestions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchRecentQuestionList(completion:@escaping ((Result<[GreenRoomQuestion],Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseURL)/api/green-questions/recent-questions")!
        
        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [GreenRoomQuestion].self) { response in
            switch response.result {

            case .success(let greenroomQuestion):
                completion(.success(greenroomQuestion))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPopularGRQuestions(completion:@escaping ((Result<[PopularQuestion],Error>) -> Void)) {
        let url = URL(string: "\(Constants.baseURL)/api/green-questions/popular-questions")!
        
        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [PopularQuestion].self) { response in
            switch response.result {

            case .success(let greenroomQuestion):
                completion(.success(greenroomQuestion))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadQuestionList(categoryId: Int, question: String, date: Date) -> Observable<Bool> {
        
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
