//
//  ProfileImageType.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/22.
//

import Foundation

enum ProfileImageType {
    case JPEG(image: Data)
    case PNG(image: Data)
    
    var description: String {
        switch self {
        case .JPEG(image: _):
            return "jpeg"
        case .PNG(image: _):
            return "png"
        }
    }
    
    var data: Data {
        switch self {
        case .PNG(image: let data):
            return data
        case .JPEG(image: let data):
            return data
            
        }
    }
}
