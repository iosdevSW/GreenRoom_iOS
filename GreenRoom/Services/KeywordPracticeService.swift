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
                    emitter.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
    }
    
    func fetchGroupList()-> Observable<[groupModel]> {
        let urlString = Storage.baseURL + "/api/groups"
        let url = URL(string: urlString)!
        
        let access = KeychainWrapper.standard.string(forKey: "accessToken")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(access)"
        ]
        
        return Observable.create{ emitter in
            let request = AF.request(url, method: .get, interceptor: AuthManager()) // 이건 왜 401에러가 날까!!!!!
            
//            let request = AF.request(url, method: .get, headers: headers)
            
            request.responseDecodable(of: [groupModel].self) { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    emitter.onNext(data)
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func addGroup(categoryId: Int, categoryName: String) {
        let urlString = Storage.baseURL + "/api/groups"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "categoryId" : categoryId,
            "name" : categoryName
        ]
        
        let request = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, interceptor: AuthManager())
        
        request.responseJSON() { res in
            print(res)
        }
        
        
    }
}
