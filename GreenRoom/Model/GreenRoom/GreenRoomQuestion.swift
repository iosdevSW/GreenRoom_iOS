//
//  ScrapQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/27.
//

import Foundation

struct GreenRoomQuestion: Codable {
    let id: Int
    let categoryName, profileImage, question, expiredAt: String
    let participated, expired: Bool
}

struct PopularQuestion: Codable {
    let id: Int
    let categoryName, profileImage, name: String
    let participants: Int
    let question, expiredAt: String
}

struct DetailQuestion: Codable {
    let id: Int
    let categoryName, profileImage, name: String
    let participants: Int
    let question, answer, expiredAt: String
    let participated: Bool
}
