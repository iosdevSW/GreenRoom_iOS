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
    ///기본,그린룸 질문조회
    func fetchReferenceQuestions(categoryId: String?, title: String?)-> Observable<[ReferenceQuestionModel]>{
        let urlString = Constants.baseURL + "/api/interview-questions"
        let url = URL(string: urlString)!
        
        var param: Parameters?
        
        if categoryId != nil || title != nil { param  = Parameters() }
        if categoryId != nil { param?["category"] = categoryId }
        if title != nil { param?["title"] = title }

        return Observable.create { emitter in
            let request = AF.request(url, method: .get, parameters: param ,encoding: URLEncoding.default, interceptor: AuthManager())
            
            request.responseDecodable(of: [ReferenceQuestionModel].self) { res in
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
    
    ///그룹에 속한 면접질문 조회
    func fetchGroupQuestions(groupId: Int)-> Observable<GroupQuestionModel> {
        let urlString = Constants.baseURL + "/api/groups/\(groupId)/questions"
        let url = URL(string: urlString)!
        
        return Observable.create { emitter in
            let request = AF.request(url, method: .get, interceptor: AuthManager())
            
            request.responseDecodable(of: GroupQuestionModel.self) { response in
                switch response.result {
                case .success(let model):
                    print(model)
                    emitter.onNext(model)
                case .failure(let error):
                    emitter.onError(error)
                    print(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
    }
    
    ///면접 연습용 질문 담기
    func addInterViewQuestion(groupId: Int, questionId: Int, questionTypeCode: Int) {
        let urlString = Constants.baseURL + "/api/interview-questions"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "groupId" : groupId,
            "questionId" : questionId,
            "questionTypeCode" : questionTypeCode
        ]
        print(param)
        
        let request = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, interceptor: AuthManager()).validate(statusCode: 200..<300)
        
        request.responseString(){ response in
            switch response.result {
            case .success(_):
                print("성공")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
    
    ///그룹 목록 조회
    func fetchGroupList()-> Observable<[GroupModel]> {
        let urlString = Constants.baseURL + "/api/groups"
        let url = URL(string: urlString)!
        
        return Observable.create{ emitter in
            let request = AF.request(url, method: .get, interceptor: AuthManager())
            request.responseDecodable(of: [GroupModel].self) { response in
                switch response.result {
                case .success(let data):
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    ///그룹 추가
    func addGroup(categoryId: Int, categoryName: String, completion: @escaping(Bool) -> Void) {
        let urlString = Constants.baseURL + "/api/groups"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "categoryId" : categoryId,
            "name" : categoryName
        ]

        let request = AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, interceptor: AuthManager()).validate(statusCode: 200..<300)
        
        request.responseString(){ response in
            switch response.result {
            case .success(_):
                completion(true)
            case .failure(let error):
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
    
    ///그룹 수정
    func editGroup(groupId: Int, categoryId: Int, categoryName: String, completion: @escaping(Bool) -> Void) {
        let urlString = Constants.baseURL + "/api/groups" + "/\(groupId)"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "categoryId" : categoryId,
            "name" : categoryName
        ]

        let request = AF.request(url, method: .put, parameters: param, encoding: JSONEncoding.default, interceptor: AuthManager()).validate(statusCode: 200..<300)
        
        request.responseString(){ response in
            switch response.result {
            case .success(_):
                completion(true)
            case .failure(let error):
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
}
