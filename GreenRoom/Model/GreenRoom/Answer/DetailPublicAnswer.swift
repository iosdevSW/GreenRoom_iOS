//
//  DetailPublicAnswer.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//

import Foundation

/// 그린룸질문 상세정보 조회 
struct DetailPublicQuestionDTO: Codable {
    let id, participants: Int
    let expiredAt, question, categoryName: String
    let participated, scrap, writer, expired: Bool
    
    var mode: PublicAnswerMode {
        if expired && participated {
            return .permission
        } else if !expired && participated {
            return .participated
        } else if expired && !participated {
            return .expires
        } else {
            return .notPermission
        }
    }
}

/** 그린룸 질문에 대한 답변*/
struct PublicAnswer: Codable {
    let id: Int
    let profileImage, answer: String
}

/** 그린룸 질문과 답변을 다루는 구조체*/
struct PublicAnswerList: Codable {
    let question: DetailPublicQuestionDTO
    var answers: [PublicAnswer]
}

/** 그린룸 질문 리스트에서 상세 답변 */
struct SpecificPublicAnswer: Codable {
    let id: Int
    let profileImage, name, answer: String
    let keywords: [String]
}
