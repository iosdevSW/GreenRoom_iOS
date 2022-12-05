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
    
    func getMinutes() -> Int {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "HH:mm"
        
        let minutes = df.string(from: self).components(separatedBy: ":")
            .compactMap { Int($0) }
        return minutes[0] * 60 + minutes[1]
    }
    
    func getRemainedTime(date: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let endTime = format.date(from: date.replacingOccurrences(of: "T", with: " ")) else {return "?"}

        var useTime = Int(endTime.timeIntervalSince(self))
        
        let hour = useTime / 3600
        
        useTime %= 3600
        
        let minute = useTime / 60
        
        return String(format: "%02d", hour) + ":" + String(format: "%02d", minute)
        
    }
}

 
