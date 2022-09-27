//
//  QuestionModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/20.
//

import Foundation

struct QuestionModel: Codable{
    let categoryName: String
    let id: Int
    let question: String
    let questionType: String
    let questionTypeCode: Int
}
