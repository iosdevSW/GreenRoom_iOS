//
//  FilteringQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/05.
//

import Foundation

/** 필터링, 검색 기능에 해당하는 질문*/
struct FilteringQuestion: Codable {
    let id: Int
    let categoryName, profileImage, name: String
    let participants: Int
    let question, answer, expiredAt: String
    let participated: Bool
}
