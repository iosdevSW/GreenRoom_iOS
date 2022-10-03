//
//  MyPublicQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/02.
//

import Foundation

struct MyPublicQuestion: Codable {
    let id: Int?
    let participants: Int
    let question: String?
    let profileImages: [String]?
    let existed, hasPrev, hasNext: Bool
}
