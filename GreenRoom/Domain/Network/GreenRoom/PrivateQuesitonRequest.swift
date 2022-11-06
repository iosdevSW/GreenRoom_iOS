//
//  PrivateQuesitonRequest.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import Alamofire

enum PrivateQuestionRequest {
    case fetch(id: Int)
    case owned
    case applyQuestion(categoryId: Int, question: String)
    case delete(id: Int)
    case applyAnswer(id: Int, answer: String, keywords: [String])
}

extension PrivateQuestionRequest: EndPoint {
    
    var baseURL: String {
        return "\(Constants.baseURL)/api/my-questions"
    }
    
    var path: String {
        switch self {
        case .fetch(id: let id):
            return "/\(id)"
        case .delete(id: let id):
            return "/\(id)"
        case .applyAnswer(id: let id, answer: _, keywords: _):
            return "/answer/\(id)"
        default: return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .applyQuestion: return .post
        case .delete: return .delete
        case .applyAnswer: return .put
        default: return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .applyQuestion(categoryId: let id, question: let question):
            return ["categoryId" : id, "question": question]
        case .applyAnswer(id: _, answer: let answer, keywords: let keywords):
            return ["answer": answer, "keywords": keywords]
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .applyQuestion, .applyAnswer:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}

