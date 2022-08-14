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

struct NameCheck: Codable {
    struct Error: Codable {
        let invalidFields: String?
        let message: String
        let status: Int
    }
    
    struct Response: Codable {
        let result: Bool
    }
    
    let error: Error?
    let response: Response?
    let success: Bool
}

struct OAuthToken {
    var accessToken: String?
    var refreshToken: String?
}
