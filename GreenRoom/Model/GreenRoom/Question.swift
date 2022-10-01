//
//  PopularQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import Foundation

struct Question: Codable {
    let image: String
    let name: String
    let participants: Int
    let category: Int
    let question: String
}


