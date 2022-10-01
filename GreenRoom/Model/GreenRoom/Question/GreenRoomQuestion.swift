//
//  ScrapQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/27.
//

import Foundation

/** 스크랩, 최근*/
struct PublicQuestion: Codable {
    let id: Int
    let categoryName, profileImage, question, expiredAt: String
    let participated, expired: Bool
    
    var remainedTime: String {
        return Date().getRemainedTime(date: expiredAt)
    }
}

struct DetailQuestion: Codable {
    let id: Int
    let categoryName, profileImage, name: String
    let participants: Int
    let question, answer, expiredAt: String
    let participated: Bool
}
