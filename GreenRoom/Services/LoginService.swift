//
//  TempFile.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import NaverThirdPartyLogin
import Alamofire
import RxSwift
import KakaoSDKUser
import SwiftKeychainWrapper

class LoginService{
    
    func loginAPI(_ accessToken: String, authType: Int)->Observable<LoginModel> {
        let urlString = Constants.baseURL + "/api/auth/login"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "accessToken" : accessToken,
            "oauthType" : authType
        ]
        
        return Observable.create{ emitter in
            let req = AF.request(url, method: .post, parameters: param ,encoding: JSONEncoding.default).validate(statusCode: 200..<300)
            req.responseDecodable(of: LoginModel.self){ res in
                switch res.result {
                case .success(let data):
                    KeychainWrapper.standard.set(authType, forKey: "oauthType")
                    emitter.onNext(data)
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    static func registUser(accessToken: String, oauthType: Int, category: Int, name: String){
        let urlString = Constants.baseURL + "/api/users/join"
        let url = URL(string: urlString)!
        
        UserDefaults.standard.set(category, forKey: "category")
        
        let param: Parameters = [
            "accessToken" : accessToken,
            "oauthType" : oauthType,
            "categoryId" : category,
            "name" : name
        ]
        
        let req = AF.request(url, method: .post, parameters: param,encoding: JSONEncoding.default)
        
        req.response(){ response in
            switch response.result {
            case .success(_):
                print("회원가입 완료")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func logout()->Observable<Bool>{
        let urlString = Constants.baseURL + "/api/auth/logout"
        let url = URL(string: urlString)!
        
        return Observable.create{ emitter in
            AF.request(url, method: .post, interceptor: AuthManager()).validate().response { response in
                switch response.result {
                case .success(_):
                    print("성공")
                    emitter.onNext(true)
                    emitter.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    static func checkName(name: String) -> Observable<Bool> {
        let urlString = Constants.baseURL + "/api/users/name"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "name" : name
        ]
        
        return Observable.create{ emitter in
            let req = AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default).validate(statusCode: 200..<300)
            req.responseString{ response in
                switch response.result {
                case .success(let isDuplicated):
                    isDuplicated == "true" ? emitter.onNext(true) : emitter.onNext(false)
                    emitter.onCompleted()
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    //    func naverLoginPaser() {
    //        let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    //
    //        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
    //
    //        if !accessToken { // 액세스 토큰이 유효하지않음
    //            return
    //        }
    //
    //        guard let tokenType = naverLoginInstance?.tokenType else { return }
    //
    //        guard let accessToken = naverLoginInstance?.accessToken else { return }
    //
    //        let requestUrl = "https://openapi.naver.com/v1/nid/me"
    //        let url = URL(string: requestUrl)!
    //
    //        let authorization = "\(tokenType) \(accessToken)"
    //
    //        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
    //
    //        req.responseJSON { response in
    //
    //            guard let body = response.value as? [String: Any] else { return }
    //
    //            if let resultCode = body["message"] as? String{
    //                if resultCode.trimmingCharacters(in: .whitespaces) == "success"{
    //                    let resultJson = body["response"] as! [String: Any]
    //
    //                    let name = resultJson["name"] as? String ?? ""
    //                    let id = resultJson["id"] as? String ?? ""
    //                    let nickName = resultJson["nickname"] as? String ?? ""
    //
    //                }else {
    //                    //실패
    //                }
    //            }
    //        }
    //    }
    
    static func generateRandomName()-> Observable<String> {
        struct Name: Codable {
            let words: [String]
            let seed: String
        }
        
        return Observable.create(){ emitter in
            let urlString = "https://nickname.hwanmoo.kr/?format=json&count=1&max_length=8"
            let url = URL(string: urlString)!
            let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            
            req.responseDecodable(of: Name.self){ response in
                switch response.result{
                case .success(let data):
                    emitter.onNext(data.words.first!) // 이름만 보내기
                    emitter.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
            
            return Disposables.create()
        }
    }
}
