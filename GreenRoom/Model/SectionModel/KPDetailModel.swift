//
//  KPDetailModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/31.
//

import RxDataSources

struct KPDetailModel {
    var items: [Item]
    
    init(items: [KPQuestion]) {
        self.items = items
    }
}

extension KPDetailModel: SectionModelType {
    typealias Item = KPQuestion
    
    init(original: KPDetailModel, items: [KPQuestion]) {
        self = original
        self.items = items
    }
    
}
