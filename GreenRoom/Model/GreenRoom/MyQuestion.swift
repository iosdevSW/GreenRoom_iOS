//
//  MyQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import Foundation

struct MyQuestion: Codable {
    let id: Int
    let groupName, groupCategoryName, categoryName, question: String
}
