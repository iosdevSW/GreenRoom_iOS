//
//  MyQuestion.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import Foundation

/** 마이질문 리스트롤 조회하는 Model*/
struct PrivateQuestion: Codable {
    let id: Int
    let groupName, groupCategoryName, categoryName, question: String
}
