//
//  KPReviewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/31.
//

import UIKit
import RxDataSources

struct KPReviewModel: SectionModelType {
    var items: [String]
    
    init(original: KPReviewModel, items: [String]) {
        self = original
        self.items = items
    }
    
    typealias Item = String
}

//enum ReviewItemType {
//    case screen
//    case question
//}
