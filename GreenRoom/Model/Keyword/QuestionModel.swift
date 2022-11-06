//
//  QuestionModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/20.
//

import UIKit
// 기본질문/ 그린룸 조회 모델
struct ReferenceModel: Codable {
    let currentPages: Int
    let totalPages: Int
    var questions: [ReferenceQuestionModel]
}

struct ReferenceQuestionModel: Codable {
    let categoryName: String
    let id: Int
    let question: String
    let questionType: String
    let questionTypeCode: Int
}

//그룹 조회 모델
struct GroupQuestionModel: Codable {
    let id: Int // 그룹 ID
    let name: String // 그룹 이름
    let categoryName: String // 카테고리 이름
    let questionCnt: Int // 면접질문 개수
    let totalPages: Int
    let groupQuestions: [GroupQuestion]
}

//그룹 질문 1개 조회 모델
struct GroupQuestionInfo: Codable {
    let id: Int
    let groupName: String
    let groupCategoryName: String
    let categoryName: String
    let question: String
    let answer: String?
    let keywords: [String]
}

//그룹 내 질문 ( 면접 연습용 질문)
struct GroupQuestion: Codable {
    let id: Int
    let categoryName: String
    let question: String
    let register: Bool
    let answer: String
    let keywords: [String]
}

//키워드 연습용
struct KPQuestion {
    let id: Int
    let categoryName: String
    let question: String
    let register: Bool
    let keyword: [String]
    let answer: String
    var sttAnswer: String?
    var persent: CGFloat?
}

func parsingKPQuestion(_ groupQuestion: GroupQuestion) -> KPQuestion {
    return KPQuestion(id: groupQuestion.id,
                      categoryName: groupQuestion.categoryName,
                      question: groupQuestion.question,
                      register: groupQuestion.register,
                      keyword: groupQuestion.keywords,
                      answer: groupQuestion.answer,
                      sttAnswer: nil,
                      persent: nil)
}
