//
//  CreateGRModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/17.
//

import Foundation
import Differentiator
import RxDataSources

struct CreateSection {
    var items: [Item]
}

extension CreateSection: SectionModelType {
    
    typealias Item = String
    
    init(original: CreateSection, items: [Item]) {
        self = original
        self.items = items
    }
}
