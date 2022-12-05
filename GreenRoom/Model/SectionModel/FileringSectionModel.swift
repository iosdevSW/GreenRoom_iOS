//
//  FileringSectionModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/02.
//

import Foundation

import Foundation
import Differentiator
import RxDataSources

struct FilteringSectionModel {
    let header: Info
    var items: [Item]
}

extension FilteringSectionModel: SectionModelType {
    
    typealias Item = FilteringQuestion
    
    init(original: FilteringSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

