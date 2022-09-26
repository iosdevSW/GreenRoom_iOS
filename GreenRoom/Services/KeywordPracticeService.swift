//
//  KeywordPracticeService.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/20.
//

import UIKit
import SwiftKeychainWrapper
import Alamofire

class KeywordPracticeService {
    func fetchReferenceQuestions(categoryId: [Int]?, title: String?, type: String?, keyword: String?){
        let urlString = Storage.baseURL + "/api/questions"
        let url = URL(string: urlString)!
        
        let accessToken = KeychainWrapper.standard.string(forKey: "accessToken")!
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
//        
//        let param: Parameters = [
////            "category" : "1",
////            "title" : ,
//            "type" : "basic",
////            "keyword" : keyword
//        ]
//        
//        let request = AF.request(url, method: .get, headers: headers)
//        request.responseJSON() { res in
//            switch res.result {
//            case .success(let data):
//                let json = data as! [String: Any]
//                print(json["message"])
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        request.responseDecodable(of: QuestionModel.self) { res in
//            switch res.result {
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//                print(error.responseCode)
//            }
//        }
    }
}
