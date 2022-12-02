//
//  APIError.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/04.
//

import Foundation

enum APIError: Error {
    /// 옳지 않은 URL
    case invalidURL
    /// response가 옳지 않을 때
    case invalidResponse
    /// 400 ~ 499에러 발생
    case badRequest(String?)
    /// 500
    case serverError(String?)
    /// Json으로 parsing 에러
    case parseError(String?)
    /// 알 수 없는 에러.
    case unknown
}
