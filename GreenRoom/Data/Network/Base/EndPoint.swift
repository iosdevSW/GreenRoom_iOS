//
//  EndPoint.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/04.
//

import Foundation
import Alamofire

typealias ReaquestHeaders = [String: String]

protocol EndPoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: ReaquestHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension EndPoint {
    var headers: ReaquestHeaders? { return nil }
    var parameter: Parameters? { return nil }
}

extension EndPoint {
    
    func getRequest() -> DataRequest? {
        guard let url = URL(string: "\(baseURL)\(path)") else { return nil }
        
        return AF.request(url, method: self.method, parameters: parameters, encoding: encoding, interceptor: AuthManager())
    }
}

