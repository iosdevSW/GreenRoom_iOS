//
//  Auth.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/27.
//

import Foundation

struct Auth: Codable {
    let accessToken, refreshToken: String
    let expiresIn, refreshTokenExpiresIn: Int
}
