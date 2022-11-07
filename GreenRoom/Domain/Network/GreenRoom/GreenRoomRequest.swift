//
//  GreenRoomRequest.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import Alamofire

enum GreenRoomRequest {
    case filtering(categoryId: Int)
    case popular
    case recent
    case owned(page: Int)
    case applyQuestion(categoryId: Int, question: String, expiredAt: String)
    case applyAnswerWithKeyword(id: Int, answer: String, keywords: [String])
    case applyAnswer(id: Int, answer: String)
    case detailQuestion(id: Int)
    case detailAnswer(id: Int)
    case detailAnswers(id: Int)
}

extension GreenRoomRequest: EndPoint {
    
    var baseURL: String {
        return "\(Constants.baseURL)/api/green-questions"
    }
    
    var path: String {
        switch self {
        case .filtering(categoryId: let id):
            return "?categoryId=\(id)"
        case .popular:
            return "/popular-questions"
        case .recent:
            return "/recent-questions"
        case .owned(page: let page):
            return page > 0 ? "/create-questions?page=\(page)": "/create-questions"
        case .detailQuestion(id: let id):
            return "/\(id)"
        case .detailAnswer(id: let id):
            return "/answer/\(id)"
        case .detailAnswers(id: let id):
            return "/\(id)/answers"
        case .applyAnswer:
            return "/answer"
        default: return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .applyQuestion, .applyAnswer: return .post
        default: return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .applyQuestion(categoryId: let id, question: let question, expiredAt: let expiredAt):
            return [
                "categoryId" : id,
                "question": question,
                "expiredAt": expiredAt]
        case .applyAnswerWithKeyword(id: let id, answer: let answer, keywords: let keywords):
            return [
                "id": id,
                "answer": answer,
                "keywords": keywords
            ]
        case .applyAnswer(id: let id, answer: let answer):
            return ["id": id, "answer": answer]
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .applyQuestion, .applyAnswer:
            return JSONEncoding.default
        default: return URLEncoding.default
        }
    }
}
