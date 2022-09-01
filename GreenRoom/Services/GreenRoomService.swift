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
        guard let url = URL(string: "\(Storage().baseURL)/api/public-questions/popular-search-words") else { return }
        
        guard let accessToken = KeychainWrapper.standard.string(forKey: "accessToken") else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, headers: headers).responseDecodable(of: [String].self) { response in
            switch response.result {
            case .success(let keywords):
                completion(.success(keywords))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
        
    }
}
