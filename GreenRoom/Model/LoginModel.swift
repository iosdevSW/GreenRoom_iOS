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
    case Common = 1
    case Intern = 2
    case IA,Design,MP,Accounting,PM,Personnel,Marketing,Sales,ITDevelopment,RD

    var title: String {
        switch self {
        case .Common: return "공통"
        case .Intern: return "인턴"
        case .IA: return "대외활동"
        case .Design: return "디자인"
        case .MP: return "경영기획"
        case .Accounting: return "회계"
        case .PM: return "생산/품질관리"
        case .Personnel: return "인사"
        case .Marketing: return "마케팅"
        case .Sales: return "영업"
        case .ITDevelopment: return "IT/개발"
        case .RD: return "연구개발(R&D)"
        }
    }
    
    var nonSelectedImage: UIImage{
        switch self {
        case .Common: return UIImage(named: "Common") ?? UIImage()
        case .Intern: return UIImage(named: "Intern") ?? UIImage()
        case .IA: return UIImage(named: "IA") ?? UIImage()
        case .Design: return UIImage(named: "Design") ?? UIImage()
        case .MP: return UIImage(named: "MP") ?? UIImage()
        case .Accounting: return UIImage(named: "Accounting") ?? UIImage()
        case .PM: return UIImage(named: "PM") ?? UIImage()
        case .Personnel: return UIImage(named: "Personnel") ?? UIImage()
        case .Marketing: return UIImage(named: "Marketing") ?? UIImage()
        case .Sales: return UIImage(named: "Sales") ?? UIImage()
        case .ITDevelopment: return UIImage(named: "ITDevelopment") ?? UIImage()
        case .RD: return UIImage(named: "RD") ?? UIImage()
        }
    }
    
    var SelectedImage: UIImage {
        switch self {
        case .Common: return UIImage(named: "CommonS") ?? UIImage()
        case .Intern: return UIImage(named: "InternS") ?? UIImage()
        case .IA: return UIImage(named: "IAS") ?? UIImage()
        case .Design: return UIImage(named: "DesignS") ?? UIImage()
        case .MP: return UIImage(named: "MPS") ?? UIImage()
        case .Accounting: return UIImage(named: "AccountingS") ?? UIImage()
        case .PM: return UIImage(named: "PMS") ?? UIImage()
        case .Personnel: return UIImage(named: "PersonnelS") ?? UIImage()
        case .Marketing: return UIImage(named: "MarketingS") ?? UIImage()
        case .Sales: return UIImage(named: "SalesS") ?? UIImage()
        case .ITDevelopment: return UIImage(named: "ITDevelopmentS") ?? UIImage()
        case .RD: return UIImage(named: "RDS") ?? UIImage()
        }
    }
}
