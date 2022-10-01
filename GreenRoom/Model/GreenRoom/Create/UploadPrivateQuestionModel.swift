//
//  UploadPrivateQuestionModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/01.
//

import Foundation

struct UploadPrivateQuestionModel: Encodable {
    let categoryId: Int
    let question: String
}
