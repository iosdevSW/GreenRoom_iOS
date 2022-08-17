//
//  TempModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation

struct LoginModel: Codable {
    let accessToken: String
    let refreshToken: String
}

struct OAuthTokenModel{
    var oauthType: Int?
    var accessToken: String?
    var refreshToken: String?
}
