//
//  PublicAnswerSectionModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//

import Foundation
import Differentiator

struct PublicAnswerSectionModel {
    let header: DetailPublicQuestionDTO
    var items: [Item]
}

extension PublicAnswerSectionModel: SectionModelType {
    
    typealias Item = PublicAnswer
    
    init(original: PublicAnswerSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
