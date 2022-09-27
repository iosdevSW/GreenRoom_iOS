//
//  KeywordPracticeService.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/20.
//

import UIKit
import SwiftKeychainWrapper
import RxSwift
import Alamofire

class KeywordPracticeService {
    func fetchReferenceQuestions(categoryId: String?, title: String?)-> Observable<[QuestionModel]>{
        let urlString = Storage.baseURL + "/api/interview-questions"
        let url = URL(string: urlString)!
        
        var param: Parameters?
        
        if categoryId != nil || title != nil { param  = Parameters() }
            
        if categoryId != nil { param?["category"] = categoryId }
        if title != nil { param?["title"] = title }
        
        return Observable.create { emitter in
            let request = AF.request(url, method: .get, parameters: param ,encoding: URLEncoding.default, interceptor: AuthManager())
            
            request.responseDecodable(of: [QuestionModel].self) { res in
                switch res.result {
                case .success(let data):
                    emitter.onNext(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
    }
}
