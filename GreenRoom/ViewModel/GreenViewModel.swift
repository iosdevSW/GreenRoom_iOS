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
    
    var keywords = BehaviorSubject<[GRSearchModel]>(value: [
        GRSearchModel.recent(header: "최근 검색어",items: []),
        GRSearchModel.popular(header: "인기 검색어", items: [])
    ])

    init(){
        self.bind()
    }
    
    func bind(){
        keywords.onNext(
            [GRSearchModel.recent(header: "최근 검색어", items:
                                    CoreDataManager.shared.loadFromCoreData(request: RecentSearchKeyword.fetchRequest()).sorted {
                                        $0.date! > $1.date!
                                    }.map {
                                        SearchTagItem(text: $0.keyword!, type: .recent)
                                    })
             ,GRSearchModel.popular(header: "인기 검색어", items: [])
            ]
        )
        
    }
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
