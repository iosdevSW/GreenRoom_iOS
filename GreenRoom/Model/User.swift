//
//  User.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/22.
//

import Foundation

struct User: Codable {
    let categoryID: Int
    let category, name, profileImage: String

    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case category, name, profileImage
    }
}

struct PresignedURL: Codable {
    let profileImage: String
}
