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
    let totalPages: Int
    let groupQuestions: [GroupQuestion]
}

struct GroupQuestion: Codable {
    let id: Int
    let categoryName: String
    let question: String
    let register: Bool
    let answer: String
    let keywords: [String]
}

struct KPQuestion {
    let id: Int
    let categoryName: String
    let question: String
    let register: Bool
    let keyword: [String]
    let sttAnswer: String?
    let answer: String
    let persent: Int?
}

func parsingKPQuestion(_ groupQuestion: GroupQuestion) -> KPQuestion {
    return KPQuestion(id: groupQuestion.id,
                      categoryName: groupQuestion.categoryName,
                      question: groupQuestion.question,
                      register: groupQuestion.register,
                      keyword: groupQuestion.keywords,
                      sttAnswer: nil,
                      answer: groupQuestion.answer,
                      persent: nil)
}
