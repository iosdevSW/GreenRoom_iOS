//
//  QNAModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/19.
//

import Foundation
import UIKit


struct FAQ {
    let question: String
    let answer: String
    
    
    var height: Int {
        return Int(Utilities.shared.heightForView(text: answer, font: .sfPro(size: 16, family: .Bold), width: UIScreen.main.bounds.width - 102))
    }
}
