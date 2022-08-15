//
//  TempModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation

struct LoginModel: Codable {
    struct Error: Codable {
        let invalidFields: String?
        let message: String
        let status: Int
    }
    
    struct Response: Codable{
        let accessToken: String
        let refreshToken: String
    }
    
    let error: Error?
    let response: Response?
    let success: Bool
}

struct OAuthTokenModel{
    var oauthType: Int?
    var accessToken: String?
    var refreshToken: String?
}
