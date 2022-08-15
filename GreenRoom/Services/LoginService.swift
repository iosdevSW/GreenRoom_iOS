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
    static let serviceURL = "https://green-room.link"
    
    func loginAPI(_ accessToken: String)->Observable<LoginModel> {
        let urlString = LoginService.serviceURL + "/api/auth/login"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "accessToken" : accessToken,
            "oauthType" : 0
        ]
        
        return Observable.create{ emitter in
            let req = AF.request(url, method: .post, parameters: param ,encoding: JSONEncoding.default).validate(statusCode: 200..<300)
            req.responseDecodable(of: LoginModel.self){ res in
                switch res.result {
                case .success(let data):
                    emitter.onNext(data)
                case .failure(let error):
                    print(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    static func registUser(accessToken: String, oauthType: Int, category: Int, name: String){
        let urlString = serviceURL + "/api/users/join"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "accessToken" : accessToken,
            "oauthType" : oauthType,
            "categoryId" : category,
            "name" : name
        ]
        
        let req = AF.request(url, method: .post, parameters: param,encoding: JSONEncoding.default)
        
        req.responseJSON(){ response in
            switch response.result {
                case .success(let data):
                print(data)
                case .failure(let error):
                print(error)
            }
        }
    }
    
    static func logout()->Observable<Bool>{
        return Observable.create{ emitter in
            UserApi.shared.logout{ error in
                if let err = error {
                    emitter.onNext(false)
                    emitter.onError(err)
                }else {
                    emitter.onNext(true)
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
        
    }
   
    static func checkName(name: String) -> Observable<Bool> {
        let urlString = serviceURL + "/api/users/name"
        let url = URL(string: urlString)!
        
        let param: Parameters = [
            "name" : name
        ]
        
        return Observable.create{ emitter in
            let req = AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default).validate(statusCode: 200..<300)
            struct NameCheck: Codable {
                struct Response: Codable{
                    let result: Bool
                }
                let response: Response
            }
            req.responseDecodable(of: NameCheck.self){ response in
                switch response.result{
                    case .success(let data):
                    emitter.onNext(data.response.result)
                    emitter.onCompleted()
                    case .failure(let error):
                        emitter.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    static func naverLoginPaser() {
        let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        guard let accessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
            
        if !accessToken { // 액세스 토큰이 유효하지않음
            return
        }
        
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        
        let requestUrl = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: requestUrl)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
        
            guard let body = response.value as? [String: Any] else { return }
            
            if let resultCode = body["message"] as? String{
                if resultCode.trimmingCharacters(in: .whitespaces) == "success"{
                    let resultJson = body["response"] as! [String: Any]
                
                    let name = resultJson["name"] as? String ?? ""
                    let id = resultJson["id"] as? String ?? ""
                    let nickName = resultJson["nickname"] as? String ?? ""

                    print("네이버 로그인 이름 ",name)
                    print("네이버 로그인 아이디 ",id)
                    print("네이버 로그인 닉네임 ",nickName)
                }else {
                    //실패
                }
            }
        }
    }
    
    static func generateRandomName()-> Observable<String> {
        struct Name: Codable {
            let words: [String]
            let seed: String
        }
        
        return Observable.create(){ m in
            let urlString = "https://nickname.hwanmoo.kr/?format=json&count=1&max_length=8"
            let url = URL(string: urlString)!
            let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            
            req.responseDecodable(of: Name.self){ response in

                switch response.result{
                    case .success(let data):
                        m.onNext(data.words.first!) // 이름만 보내기
                        m.onCompleted()
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                }
            }
            
            return Disposables.create()
        }
    }
}
