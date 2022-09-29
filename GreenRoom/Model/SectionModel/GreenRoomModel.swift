//
//  GreenRoomSection.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import Foundation

import UIKit
import Differentiator

enum GreenRoomSectionModel: SectionModelType {
    
    typealias Item = SectionItem
    
    enum SectionItem {
        case filtering(interest: String)
        case popular(question: PopularQuestion)
        case recent(question: GreenRoomQuestion)
        case MyGreenRoom(question: Question)
        case MyQuestionList(question: MyQuestion)
    }
    
    case filtering(items: [Item])
    case popular(items: [Item])
    case recent(items: [Item])
    case MyGreenRoom(items: [Item])
    case MyQuestionList(items: [Item])
    
    init(original: GreenRoomSectionModel, items: [Item]) {
        switch original {
        case .filtering(items: let items):
            self = .filtering(items: items)
        case .popular(items: let items):
            self = .popular(items: items)
        case .recent(items: let items):
            self = .recent(items: items)
        case .MyGreenRoom(items: let items):
            self = .MyGreenRoom(items: items)
        case .MyQuestionList(items: let items):
            self = .MyQuestionList(items: items)
        }
    }

    var items: [SectionItem] {
        switch self {
        case .filtering(items: let items):
            return items
        case .popular(items: let items):
            return items
        case .recent(items: let items):
            return items
        case .MyGreenRoom(items: let items):
            return items
        case .MyQuestionList(items: let items):
            return items
        }
    }
}
