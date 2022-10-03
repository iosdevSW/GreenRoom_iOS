//
//  AnswerMode.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import Foundation

enum PrivateAnswerMode: Equatable {
    
    case edit
    case written(answer: String)
    case unWritten
    
}
