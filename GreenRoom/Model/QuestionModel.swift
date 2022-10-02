//
//  QuestionModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/20.
//

import Foundation

struct ReferenceQuestionModel: Codable {
    let categoryName: String
    let id: Int
    let question: String
    let questionType: String
    let questionTypeCode: Int
}

struct GroupQuestionModel: Codable {
    let id: Int // 그룹 ID
    let name: String // 그룹 이름
    let categoryName: String // 카테고리 이름
    let questionCnt: Int // 면접질문 개수
    let groupQuestions: [GroupQuestion]
}

struct GroupQuestion: Codable {
    let id: Int
    let categoryName: String
    let question: String
    let register: Bool
}
