//
//  KeywordViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import RxCocoa
import RxSwift

class KeywordViewModel {
    let disposeBag = DisposeBag()
    
    let selectedGroupID = BehaviorRelay<Int?>(value: nil) // 선택한 그룹 ID
    
    let groupInfo = BehaviorRelay<GroupQuestionModel?>(value: nil) // 선택한 그룹 정보 모델
    
    let groupQuestions = BehaviorRelay<[GroupQuestion]>(value: []) // 선택한 그룹의 질문리스트
    
    let selectedQuestions = BehaviorRelay<[GroupQuestion]>(value: []) // 선택한 질문들
    
    let selectedQuestionObservable = BehaviorRelay<[String]>.init(value: []) // 선택된 연습 질문 (임시, 제거 예정)

    var selectedQ = BehaviorSubject<[KPDetailModel]>.init(value:[ // 임시 ( 제거 예정 )
        KPDetailModel.init(items: [])
    ])
    
    let groupEditMode = BehaviorRelay<Bool>(value: false) // 그룹 편집 모드 여부
    
    var keywordOnOff = true
    var recordingType: RecordingType = .camera
    var goalPersent: CGFloat?
    var videoURLs: [URL]?
    
    init(){
        selectedQuestionObservable.subscribe(onNext: { str in
            self.selectedQ.onNext([KPDetailModel(items: str)])
        }).disposed(by: disposeBag)
        
        groupInfo
            .map { $0?.groupQuestions}
            .subscribe(onNext: { [weak self] questions in
                if let questions = questions {
                    self?.groupQuestions.accept(questions)
                } else {
                    self?.groupQuestions.accept([])
                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateGroupQuestions() {
        guard let groupID = self.selectedGroupID.value else {
            groupInfo.accept(nil)
            return
        }
        
        KeywordPracticeService().fetchGroupQuestions(groupId: groupID)
            .bind(to: self.groupInfo)
            .disposed(by: disposeBag)
    }
}
