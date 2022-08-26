//
//  PopularQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import Foundation

struct Question: Codable {
    let id: Int
    let profileImage, category, question: String
}
