//
//  ScrapService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/27.
//

import Foundation
import RxSwift
import Alamofire

final class ScrapService {
    
    func fetchScrapQuestions() -> Observable<[ScrapQuestion]> {
        let url = URL(string: "\(Constants.baseURL)/api/green-questions/scrap")!
        
        return Observable.create { emitter in
            AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [ScrapQuestion].self) { response in
                    switch response.result {
                    case .success(let scrapQuestions):
                        emitter.onNext(scrapQuestions)
                    case .failure(let error):
                        emitter.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}
