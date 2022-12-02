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
}
