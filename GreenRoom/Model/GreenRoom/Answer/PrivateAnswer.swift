//
//  PrivateAnswer.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//

import Foundation

struct PrivateAnswer: Codable {
    let id: Int
    let groupCategoryName, categoryName, question: String
    let answer: String?
    let keywords: [String]
    
   
    enum CodingKeys: String, CodingKey {
        case id, groupCategoryName, categoryName, question, answer, keywords
    }
}
