//
//  SearchRequest.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import Alamofire

enum SearchRequest {
    case popular
    case question(text: String)
}

extension SearchRequest: EndPoint {
    
    var baseURL: String {
        return "\(Constants.baseURL)/api/green-questions"
    }
    
    var path: String {
        switch self {
        case .popular:
            return "/popular-search-words"
        case .question:
            return "/search"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .question(let text):
            return ["title": text]
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .question:
            return URLEncoding.queryString
        case .popular:
            return URLEncoding.default
        }
    }
}
