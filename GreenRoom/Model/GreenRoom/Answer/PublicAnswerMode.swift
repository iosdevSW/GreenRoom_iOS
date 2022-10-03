//
//  PublicAnswerMode.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/03.
//

import Foundation

enum PublicAnswerMode {
    
    case notPermission
    case permission
    case participated
    case expires
    
    var title: String {
        switch self {
        case .participated: return "참여완료"
        case .expires: return "답변 시간이 종료 되었어요 :("
        case .notPermission: return "작성 시 동료의 답변을 볼 수 있어요!"
        case .permission: return ""
        }
    }
    
    func isVisibility(expired:Bool, pariticipated: Bool) -> Bool {
        return expired && pariticipated
    }
}
