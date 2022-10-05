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
    
    //MARK: - 조회
    /** 내가 관심있어 하는 직무에 대한 질문들 조회*/
    func fetchFilteredQuestion(categoryId: Int) -> Observable<[FilteringQuestion]> {
        
        let requestURL = baseURL +  "?categoryId=\(categoryId)"
        
        return Observable.create { emitter in
            
            AF.request(requestURL, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [FilteringQuestion].self) { response in
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
    
    /** 최근 그린룸 질문 조회*/
    func fetchRecentPublicQuestions() -> Observable<[PublicQuestion]>{
        let requestURL = baseURL + "/recent-questions"
        
        return Observable.create { emmiter in
            AF.request(requestURL, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [PublicQuestion].self) { response in
                    
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
    
    /** 내가 생성한 그린룸 질문 */
    func fetchPublicQuestions(page: Int = 0) -> Observable<MyPublicQuestion>{
        
        let requestURL = baseURL + "/create-questions"
        
        return Observable.create { emitter in
            AF.request(requestURL, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: MyPublicQuestion.self) { response in
                    switch response.result {
                    case .success(let question):
                        emitter.onNext(question)
                    case .failure(let error):
                        emitter.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    /** 그린룸질문 상세정보 조회 */
    func fetchDetailPublicQuestion(id: Int) -> Observable<DetailPublicAnswer> {
        let requestURL = baseURL + "/\(id)"
        
        return Observable.create { emitter in
            AF.request(requestURL, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: DetailPublicQuestionDTO.self) { response in
                    switch response.result {
                    case .success(let question):

                        var output = DetailPublicAnswer(question: question, answers: [PublicAnswer(id: 0, profileImage: "", answer: ""),PublicAnswer(id: 0, profileImage: "", answer: ""),PublicAnswer(id: 0, profileImage: "", answer: ""),PublicAnswer(id: 0, profileImage: "", answer: "")])
                        
                        if question.participated && question.expired {
                            self.fetchDetailAnswer(id: question.id) { result in
                                switch result {
                                case .success(let answers):
                                    output.answers = answers
                                case .failure(_):
                                    break
                                }
                            }
                        }
                        emitter.onNext(output)
                    case .failure(let error):
                        emitter.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
    func fetchDetailAnswer(id: Int, completion: @escaping(Result<[PublicAnswer], Error>) -> Void){
        let requestURL = baseURL + "/\(id)/answers"
        
        AF.request(requestURL, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [PublicAnswer].self) { response in
                switch response.result {
                case .success(let question):
                    completion(.success(question))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    //MARK: - 생성
    /** 인기있는 그린룸 질문 조회*/
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
    /** 그린룸 질문 생성*/
    func uploadQuestionList(categoryId: Int, question: String, expiredAt: String) -> Observable<Bool> {
        
        let parameters: Parameters = [
            "categoryId" : categoryId,
            "question": question,
            "expiredAt": expiredAt
        ]
        
        return Observable.create { emitter in
            AF.request(self.baseURL, method: .post, parameters: parameters, encoding:JSONEncoding.default, interceptor: AuthManager()).responseString { response in
                
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
    
    
    /** 그린룸 질문에 대한 답변 등록*/
    func uploadAnswer(id: Int, answer: String, keywords: [String]) -> Observable<Bool> {
        let requestURL = baseURL + "/answer"
        
        let parameters: Parameters = [
            "id": id,
            "answer": answer,
            "keywords": keywords
        ]
        
        return Observable.create { emitter in
            AF.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let stre):
                        print(stre)
                        emitter.onNext(true)
                    case .failure(_):
                        emitter.onNext(false)
                    }
                }
            return Disposables.create()
        }
    }
    
    func participateGreenRoom(groupId: Int, questionId: Int) -> Observable<Bool> {
        
        let requestURL = baseURL + "/group"
        
        let parameters: Parameters = [
            "groupId": groupId,
            "questionId": questionId
        ]
        
        return Observable.create { emitter in
            AF.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseString { response in
                    switch response.result {
                    case .success(let stre):
                        print(stre)
                        emitter.onNext(true)
                    case .failure(_):
                        emitter.onNext(false)
                    }
                }
            return Disposables.create()
        }
    }
}
