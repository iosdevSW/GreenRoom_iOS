//
//  MyPageModels.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/16.
//

import Foundation
import UIKit
import Differentiator

enum MyPageSectionModel: SectionModelType {
    
    typealias Item = SectionItem
    
    case profile(items: [Item])
    case setting(header: String, items: [Item])
    
    enum SectionItem {
        case profile(profileInfo: ProfileItem)
        case setting(settingInfo: InfoItem)
    }
    
    var items: [SectionItem] {
        switch self {
        case .profile(items: let items):
            return items.map{$0}
        case .setting(header: _, items: let items):
            return items.map{$0}
        }
    }
    
    init(original: MyPageSectionModel, items: [Item]) {
        switch original {
        case .profile(let items):
            self = .profile(items: items)
        case .setting(let header, let items):
            self = .setting(header: header, items: items)
        }
    }
}

struct ProfileItem: Equatable {
    let profileImage: UIImage?
    let nameText: String
    let emailText: String?
}

struct InfoItem: Equatable{
    let iconImage: UIImage?
    let title: String
    let setting: Setting
}

enum Setting {
    case notification
    case language
    case interest
    case invitation
    case version
    case FAQ
    case QNA
}
