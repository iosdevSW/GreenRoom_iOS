//
//  QuestionModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/20.
//

import Foundation

struct QuestionModel: Codable{
    struct Message: Codable {
        let questionId: Int
        let answerId: Int?
        let category: String
        let questionType: String
        let question: String
        let hasAnswer: Bool
        let hasKeyword: Bool
    }
    
    let message: [Message]
    
}
