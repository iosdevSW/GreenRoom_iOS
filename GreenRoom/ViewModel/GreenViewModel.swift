//
//  GreenViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import SwiftKeychainWrapper
import RxSwift

class GreenRoomViewModel {
    
    let observable: Observable<[GRSearchModel]> = Observable.of(
        [GRSearchModel.recent(header: "최근검색어",items:
                                [SearchTagItem(text: "공통", type: .recent),
                                 SearchTagItem(text: "인턴", type: .recent),
                                 SearchTagItem(text: "대외활동", type: .recent),
                                 SearchTagItem(text: "디자인", type: .recent),
                                 SearchTagItem(text: "경영기획", type: .recent),
                                 SearchTagItem(text: "회계", type: .recent),
                                 SearchTagItem(text: "생산/품질관리", type: .recent),
                                 SearchTagItem(text: "생산/품질관리", type: .recent),
                                 SearchTagItem(text: "인사", type: .recent),SearchTagItem(text: "마케팅", type: .recent),
                                 SearchTagItem(text: "영업", type: .recent),
                                 SearchTagItem(text: "IT/개발", type: .recent),
                                 SearchTagItem(text: "연구개발(R&D)", type: .recent)]),
         GRSearchModel.recent(header: "인기검색어",items:
                                [SearchTagItem(text: "공통", type: .popular),
                                 SearchTagItem(text: "인턴", type: .popular),
                                 SearchTagItem(text: "대외활동", type: .popular),
                                 SearchTagItem(text: "디자인", type: .popular),
                                 SearchTagItem(text: "경영기획", type: .popular),
                                 SearchTagItem(text: "회계", type: .popular),
                                 SearchTagItem(text: "생산/품질관리", type: .popular),
                                 SearchTagItem(text: "생산/품질관리", type: .popular),
                                 SearchTagItem(text: "인사", type: .popular),SearchTagItem(text: "마케팅", type: .popular),
                                 SearchTagItem(text: "영업", type: .popular),
                                 SearchTagItem(text: "IT/개발", type: .popular),
                                 SearchTagItem(text: "연구개발(R&D)", type: .popular)])
         ])
    //        "공통","인턴","대외활동","디자인","경영기획","회계","생산/품질관리","인사","마케팅","영업","IT/개발","연구개발(R&D)")
    
    //    let popularObservable = Observable.of()
    
    func isLogin()->Observable<Bool> {
        if let accessToken = KeychainWrapper.standard.string(forKey: "accessToken"){
            return Observable.create{ emitter in
                //accessToken 유효성 체크 부분, 유효하면 true
                // 유효하지 않으면 refreshtoken통해 재발급
                // refreshtoken도 유효하지 않으면 false
                // 일단 유효성 체크 API가 없어서 있으면 넘어가는 것만 구현
                emitter.onNext(true)
                return Disposables.create()
            }
            
        }else {
            return Observable.create{ emitter in
                emitter.onNext(false)
                emitter.onCompleted()
                
                return Disposables.create()
            }
        }
    }
}
