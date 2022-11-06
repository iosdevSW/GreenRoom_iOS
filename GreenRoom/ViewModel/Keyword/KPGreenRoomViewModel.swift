//
//  KPGreenRoomViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/11/06.
//

import UIKit
import RxSwift
import RxCocoa

class KPGreenRoomViewModel {
    let disposeBag = DisposeBag()
    
    let greenRoomQuestions = BehaviorRelay<[KPGreenRoomQuestion]>(value: []) // 그린룸 질문들
    
    
    init(){
        KeywordPracticeService().fetchInvolveQuestions()
            .bind(to: greenRoomQuestions)
            .disposed(by: disposeBag)
    }
}
