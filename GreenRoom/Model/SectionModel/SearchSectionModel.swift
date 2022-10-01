//
//  GRSearchModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/25.
//

import Foundation
import Differentiator

enum SearchSectionModel: SectionModelType {

    typealias Item = SearchTagItem
    
    case recent(header: String, items: [Item])
    case popular(header: String, items: [Item])
  
    var items: [SearchTagItem] {
        switch self {
        case .popular(header:_, items: let items):
            return items.map { $0 }
        case .recent(header:_, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: SearchSectionModel, items: [Item]) {
        switch original {
        case .recent(header: let header, let items):
            self = .recent(header: header, items: items)
        case .popular(header: let header, let items):
            self = .popular(header: header, items: items)
        }
    }

}

enum SearchState {
    case recent
    case popular
    
    var borderColor: UIColor{
        switch self {
        case .popular:
            return .mainColor
        case .recent:
            return .customGray
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .recent:
            return .white
        case .popular:
            return UIColor(red: 248/255.0, green: 254/255.0, blue: 251/255.0, alpha: 1.0)
        }
    }
    
    var title: String {
        switch self {
        case .popular: return "인기 검색어"
        case .recent: return "최근 검색어"
        }
    }
}

struct SearchTagItem {
    let text: String
    let type: SearchState
}
