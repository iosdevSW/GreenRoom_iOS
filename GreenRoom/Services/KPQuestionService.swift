//
//  KPQuestionService.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/10/10.
//

import Foundation
import RxSwift
import Alamofire

class KPQuestionService {
    /// 그룹질문 답변, 키워드 수정/등록
    func uploadAnswer(id: Int, answer: String?, keywords: [String]?) -> Observable<Bool> {
        let urlString = Constants.baseURL + "api/interview-questions/answer/\(id)"
        let url = URL(string: urlString)!
        
        var param: Parameters?
       
        if answer != nil || keywords != nil { param = Parameters() }
        if let answer = answer { param?["answer"] = answer }
        if let keywords = keywords { param?["keywords"] = keywords }
        
        
        
        return Observable.create { emitter in

            
            AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, interceptor: AuthManager())
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
    
    ///그룹질문 삭제
    func deleteGroupQuestions(groupId: Int, questionIds: [Int], completion: @escaping(Bool) -> Void) {
        let urlString = Constants.baseURL + "/api/groups/delete-questions"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "groupId" : groupId,
            "ids" : questionIds
        ]
        
        let request = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, interceptor: AuthManager()).validate(statusCode: 200..<300)
        
        request.response { res in
            switch res.result {
            case .success(_):
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// 특정그룹질문 키워드,답변 조회
    func fetchGroupQuestion(id: Int) -> Observable<GroupQuestion> {
        let urlString = Constants.baseURL + "api/interview-questions/\(id)"
        let url = URL(string: urlString)!

        return Observable.create { emitter in
            AF.request(url, encoding: JSONEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GroupQuestion.self) { response in
                    switch response.result {
                    case .success(let question):
                        print("suc")
                        emitter.onNext(question)
                    case .failure(let error):
                        print(error.errorDescription)
                        emitter.onError(error)
                    }
                }

            return Disposables.create()
        }
    }
}
