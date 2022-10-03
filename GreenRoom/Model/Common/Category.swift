//
//  Category.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/02.
//

import Foundation

enum Category: Int {
    
    case common = 1, intern, ia, design , mp, accounting, pm, personnel, marketing, sales, itDevelopment, rd

    var title: String {
        switch self {
        case .common: return "공통"
        case .intern: return "인턴"
        case .ia: return "대외활동"
        case .design: return "디자인"
        case .mp: return "경영기획"
        case .accounting: return "회계"
        case .pm: return "생산/품질관리"
        case .personnel: return "인사"
        case .marketing: return "마케팅"
        case .sales: return "영업"
        case .itDevelopment: return "IT/개발"
        case .rd: return "연구개발(R&D)"
        }
    }
    
    var defaultImageName: String {
        switch self {
        case .common: return "Common"
        case .intern: return "Intern"
        case .ia: return "IA"
        case .design: return "Design"
        case .mp: return "MP"
        case .accounting: return "Accounting"
        case .pm: return "PM"
        case .personnel: return "Personnel"
        case .marketing: return "Marketing"
        case .sales: return "Sales"
        case .itDevelopment: return "ITDevelopment"
        case .rd: return "RD"
        }
    }
    
    var selectedImageName: String {
        switch self {
        case .common: return "CommonS"
        case .intern: return "InternS"
        case .ia: return "IAS"
        case .design: return "DesignS"
        case .mp: return "MPS"
        case .accounting: return "AccountingS"
        case .pm: return "PMS"
        case .personnel: return "PersonnelS"
        case .marketing: return "MarketingS"
        case .sales: return "SalesS"
        case .itDevelopment: return "ITDevelopmentS"
        case .rd: return "RDS"
        }
    }
}

