//
//  GreenRoomService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/29.
//

import Foundation
import Alamofire
import RxSwift

final class SearchService {
    
    func fetchPopularKeywords() -> Observable<[String]>{
        let url = Constants.baseURL + "/api/green-questions/popular-search-words"
        
        return Observable.create { emitter in
            AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [String].self) {
                    response in
                    switch response.result {
                    case .success(let keywords):
                        emitter.onNext(keywords)
                    case .failure(let error):
                        emitter.onError(error)
                    }
                }
            return Disposables.create()
        }
        
    }
}
