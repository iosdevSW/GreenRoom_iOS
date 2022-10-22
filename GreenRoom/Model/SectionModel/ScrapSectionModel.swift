//
//  ScrapSectionModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/27.
//

import Foundation
import Differentiator
import RxDataSources

struct ScrapSectionModel {
    var items: [Item]
}

extension ScrapSectionModel: SectionModelType {
    
    typealias Item = GreenRoomQuestion
    
    init(original: ScrapSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
