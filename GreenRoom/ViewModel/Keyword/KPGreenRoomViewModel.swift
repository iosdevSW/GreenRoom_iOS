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
    
    let selectedQuestionObservable = BehaviorRelay<KPGreenRoomQuestion?>(value: nil) // 선택된 질문
    
    let filteringQuestions = BehaviorRelay<String?>(value: nil) // 필터링되는 카테고리
    
    let isEmptyQuestions = BehaviorRelay<Bool>(value: false) // 질문 개수 카운트
    
    
    init(){
        KeywordPracticeService().fetchInvolveQuestions()
            .bind(to: greenRoomQuestions)
            .disposed(by: disposeBag)
        
        KeywordPracticeService().fetchInvolveQuestions()
            .map { $0.count == 0 }
            .bind(to: isEmptyQuestions)
            .disposed(by: disposeBag)
        
        filteringQuestions
            .bind(onNext: { idString in
            self.updateQuestions(idString)
        }).disposed(by: disposeBag)
    
    }
    
    func updateQuestions(_ idString: String?) {
        KeywordPracticeService().fetchInvolveQuestions(category: idString)
            .take(1)
            .bind(to: greenRoomQuestions)
            .disposed(by: disposeBag)
    }
}
