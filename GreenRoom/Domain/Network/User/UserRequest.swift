//
//  UserRequest.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import Alamofire

enum UserRequest {
    case userInfo
    case presignedURL(profileImage: String)
//    case uploadImage(url: String, image: Data)
    case uploadNickname(name: String)
    case uploadCategory(categoryId: Int)
}

extension UserRequest: EndPoint {
    var baseURL: String {
        return Constants.baseURL + "/api/users"
    }
    
    var path: String {
        switch self {
        case .presignedURL:
            return "/profile-image"
        default:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userInfo:
            return .get
        case .presignedURL, .uploadNickname, .uploadCategory:
            return .put
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .presignedURL(profileImage: let description):
            return ["profileImage": description]
//            "user-profile-image.\(imageData.description)"]
        case .userInfo: return nil
        case .uploadNickname(name: let name):
            return ["name": name]
        case .uploadCategory(categoryId: let id):
            return ["categoryId": id]
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .userInfo:
            return URLEncoding.default
        case .presignedURL, .uploadNickname, .uploadCategory:
            return JSONEncoding.default
        }
    }
    
}
    
