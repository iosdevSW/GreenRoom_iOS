//
//  ScrapQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/27.
//

import Foundation

struct ScrapQuestion: Codable {
    let id: Int
    let categoryName, profileImage, question, expiredAt: String
    let participated, expired: Bool
}
