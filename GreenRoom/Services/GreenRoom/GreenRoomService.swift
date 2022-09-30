//
//  GreenRoomService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/29.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire
import RxCocoa

final class GreenRoomService {
    
    func fetchPopularKeywords(completion:@escaping (Result<[String],Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/api/public-questions/popular-search-words") else { return }
        
        AF.request(url, method: .get, encoding: URLEncoding.default, interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [String].self) {
                response in
                print("DEBUG: \(response.result)")
                switch response.result {
                case .success(let keywords):
                    completion(.success(keywords))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
