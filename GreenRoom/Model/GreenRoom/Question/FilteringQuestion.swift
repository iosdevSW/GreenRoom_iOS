//
//  FilteringQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/05.
//

import Foundation

struct FilteringQuestion: Codable {
    let id: Int
    let categoryName, profileImage, name: String
    let participants: Int
    let question, answer, expiredAt: String
    let participated: Bool
}

