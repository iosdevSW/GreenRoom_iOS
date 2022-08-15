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
