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
    
    init(original: GreenRoomSectionModel, items: [Item]) {
        switch original {
        case .popular(items: let items):
            self = .popular(items: items)
        case .recent(items: let items):
            self = .recent(items: items)
        }
    }
    
    case popular(items: [Item])
    case recent(items: [Item])

    enum SectionItem {
        case popular(question: Question)
        case recent(question: Question)
        case MyGreenRoom(question: Question)
    }
    
    var items: [SectionItem] {
        switch self {
        case .popular(items: let items):
            return items.map{ $0 }
        case .recent(items: let items):
            return items.map { $0 }
        }
    }
}
