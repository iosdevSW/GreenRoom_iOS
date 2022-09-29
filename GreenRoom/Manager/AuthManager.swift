//
//  AuthManager.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/03.
//

import Alamofire
import SwiftKeychainWrapper

class AuthManager: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        guard urlRequest.url?.absoluteString.hasPrefix(Constants.baseURL) == true,
              let accessToken = KeychainWrapper.standard.string(forKey: "accessToken") else { return }
        
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: accessToken))

        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        guard let url = URL(string: "\(Constants.baseURL)/api/auth/reissue") else { return }
        
        guard let accessToken = KeychainWrapper.standard.string(forKey: "accessToken"),
                let refreshToken = KeychainWrapper.standard.string(forKey: "refreshToken") else { return }
        
        print(accessToken, refreshToken)
        
        let paramters: Parameters = [
            "accessToken": accessToken,
            "refreshToken": refreshToken
        ]
        
        AF.request(url,method: .post, parameters: paramters ,encoding: JSONEncoding.default)
            .responseString {
//        responseDecodable(of: Auth.self) {
            response in
            
            switch response.result {
            case .success(let token):
                print(token)
                KeychainWrapper.standard.removeAllKeys()
//                KeychainWrapper.standard.set(token.refreshToken, forKey: "RefreshToken")
//                KeychainWrapper.standard.set(token.accessToken, forKey: "AccessToken")
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
        
    }
}
