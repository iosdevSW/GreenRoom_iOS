//
//  TempModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import UIKit

struct LoginModel: Codable {
    let accessToken: String
    let refreshToken: String
}

struct OAuthTokenModel{
    var oauthType: Int?
    var accessToken: String?
    var refreshToken: String?
}

enum CategoryID: Int {
    case common = 1
    case intern = 2
    case ia,design,mp,accounting,pm,personnel,marketing,sales,itDevelopment,rd

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
    
    var nonSelectedImage: UIImage{
        switch self {
        case .common: return UIImage(named: "Common") ?? UIImage()
        case .intern: return UIImage(named: "Intern") ?? UIImage()
        case .ia: return UIImage(named: "IA") ?? UIImage()
        case .design: return UIImage(named: "Design") ?? UIImage()
        case .mp: return UIImage(named: "MP") ?? UIImage()
        case .accounting: return UIImage(named: "Accounting") ?? UIImage()
        case .pm: return UIImage(named: "PM") ?? UIImage()
        case .personnel: return UIImage(named: "Personnel") ?? UIImage()
        case .marketing: return UIImage(named: "Marketing") ?? UIImage()
        case .sales: return UIImage(named: "Sales") ?? UIImage()
        case .itDevelopment: return UIImage(named: "ITDevelopment") ?? UIImage()
        case .rd: return UIImage(named: "RD") ?? UIImage()
        }
    }
    
    var SelectedImage: UIImage {
        switch self {
        case .common: return UIImage(named: "CommonS") ?? UIImage()
        case .intern: return UIImage(named: "InternS") ?? UIImage()
        case .ia: return UIImage(named: "IAS") ?? UIImage()
        case .design: return UIImage(named: "DesignS") ?? UIImage()
        case .mp: return UIImage(named: "MPS") ?? UIImage()
        case .accounting: return UIImage(named: "AccountingS") ?? UIImage()
        case .pm: return UIImage(named: "PMS") ?? UIImage()
        case .personnel: return UIImage(named: "PersonnelS") ?? UIImage()
        case .marketing: return UIImage(named: "MarketingS") ?? UIImage()
        case .sales: return UIImage(named: "SalesS") ?? UIImage()
        case .itDevelopment: return UIImage(named: "ITDevelopmentS") ?? UIImage()
        case .rd: return UIImage(named: "RDS") ?? UIImage()
        }
    }
}
