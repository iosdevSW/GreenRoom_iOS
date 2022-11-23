//
//  RegisterKeywordRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import RxSwift
import Alamofire

protocol RegisterKeywordRepositoryInterface {
    func fetchPrivateQuestion(id: Int) -> Observable<PrivateAnswer>
    func fetchGroupQuestion(id: Int) -> Observable<GroupQuestionInfo>
}

final class RegisterKeywordRepository: RegisterKeywordRepositoryInterface {
    func fetchPrivateQuestion(id: Int) -> Observable<PrivateAnswer> {
        let request = PrivateQuestionRequest.fetch(id: id)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: PrivateAnswer.self, decoder: JSONDecoder())
    }
    
    /// 특정그룹질문 키워드,답변 조회
    func fetchGroupQuestion(id: Int) -> Observable<GroupQuestionInfo> {
        let urlString = Constants.baseURL + "/api/interview-questions/\(id)"
        let url = URL(string: urlString)!

        return Observable.create { emitter in
            AF.request(url, method: .get, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: GroupQuestionInfo.self) { response in
                    switch response.result {
                    case .success(let question):
                        emitter.onNext(question)
                    case .failure(let error):
                        print(error.localizedDescription)
                        emitter.onError(error)
                    }
                }

            return Disposables.create()
        }
    }
}
