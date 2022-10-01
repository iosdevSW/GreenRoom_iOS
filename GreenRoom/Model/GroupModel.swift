//
//  GroupModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/30.
//

import UIKit

struct GroupModel: Codable {
    let id: Int
    let name: String
    let categoryName: String
    let questionCnt: Int
}

enum GroupStatus {
    case zero
    case notZero
}
