//
//  KPDetailModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/31.
//

import RxDataSources

struct KPDetailModel {
    var items: [Item]
    
    init(items: [String]) {
        self.items = items
    }
}

extension KPDetailModel: SectionModelType {
    typealias Item = String
    
    init(original: KPDetailModel, items: [String]) {
        self = original
        self.items = items
    }
    
}
