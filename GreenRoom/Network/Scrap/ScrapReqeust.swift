//
//  ScrapReqeust.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/04.
//

import Foundation
import Alamofire

enum ScrapRequest {
    case fetchQuestions
    case update(id: Int)
    case delete(ids: [Int])
}

extension ScrapRequest: EndPoint {
    
    var baseURL: String {
        return "\(Constants.baseURL)/api/green-questions"
    }
    
    var path: String {
        switch self {
        case .delete:
            return "/delete-scrap"
        default:
            return "/scrap"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchQuestions: return .get
        case .delete, .update: return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .update(let id):
            return ["id": id]
        case .delete(ids: let ids):
            return ["ids": ids]
        default: return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .fetchQuestions:
            return URLEncoding.default
        case .delete, .update:
            return JSONEncoding.default
        }
    }
    
    var interceptor: RequestInterceptor? {
        return AuthManager()
    }
}
