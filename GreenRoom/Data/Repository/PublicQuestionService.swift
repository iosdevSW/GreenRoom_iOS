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
    /** 인기있는 그린룸 질문 조회*/
    /** 내가 생성한 그린룸 질문 */
    /** 그린룸질문 상세정보 조회 */
//    func fetchDetailPublicQuestion(id: Int) -> Observable<PublicAnswerList> {
//        let requestURL = baseURL + "/\(id)"
//        
//        return Observable.create { emitter in
//            AF.request(requestURL, encoding: URLEncoding.default, interceptor: AuthManager())
//                .validate(statusCode: 200..<300)
//                .responseDecodable(of: DetailPublicQuestionDTO.self) { response in
//                    
//                    switch response.result {
//                    case .success(let question):
//                        var output = PublicAnswerList(
//                            question: question,
//                            answers: [
//                                PublicAnswer(id: 0, profileImage: "", answer: ""),
//                                PublicAnswer(id: 0, profileImage: "", answer: ""),
//                                PublicAnswer(id: 0, profileImage: "", answer: ""),
//                                PublicAnswer(id: 0, profileImage: "", answer: "")]
//                        )
//                       
//                        if question.participated && question.expired {
//                            self.fetchDetailAnswers(id: question.id) { result in
//                                switch result {
//                                case .success(let answers):
//                                    output.answers = answers
//                                    emitter.onNext(output)
//                                case .failure(_):
//                                    break
//                                }
//                            }
//                        } else {
//                            emitter.onNext(output)
//                        }
//                        
//                    case .failure(let error):
//                        emitter.onError(error)
//                    }
//                }
//            return Disposables.create()
//        }
//    }
//    
  

    
    //MARK: - 생성
  
    /** 그린룸 질문 생성*/
    /** 그린룸 질문에 대한 답변 등록*/
//    func uploadAnswer(id: Int, answer: String, keywords: [String]) -> Observable<Bool> {
//        let requestURL = baseURL + "/answer"
//        
//        let parameters: Parameters = [
//            "id": id,
//            "answer": answer,
//            "keywords": keywords
//        ]
//        
//        return Observable.create { emitter in
//            AF.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, interceptor: AuthManager())
//                .validate(statusCode: 200..<300)
//                .responseString { response in
//                    switch response.result {
//                    case .success(let stre):
//                        print(stre)
//                        emitter.onNext(true)
//                    case .failure(_):
//                        emitter.onNext(false)
//                    }
//                }
//            return Disposables.create()
//        }
//    }
    
    /// 내가 참여한 그린룸 질문 조회
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
    
    /// 검색 기능
//    func searchGreenRoomQuestion(keyword: String) -> Observable<[FilteringQuestion]> {
//        let url = Constants.baseURL + "/api/green-questions/search?title=\(keyword)"
//        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//        return Observable.create { emitter in
//            AF.request(encodedString, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
//                .validate(statusCode: 200..<300)
//                .responseDecodable(of: [FilteringQuestion].self) {
//                    response in
//                    switch response.result {
//                    case .success(let keywords):
//                        emitter.onNext(keywords)
//                    case .failure(let error):
//                        emitter.onError(error)
//                    }
//                }
//            return Disposables.create()
//        }
//    }
}
