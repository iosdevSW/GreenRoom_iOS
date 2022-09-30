//
//  Date.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import Foundation

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

