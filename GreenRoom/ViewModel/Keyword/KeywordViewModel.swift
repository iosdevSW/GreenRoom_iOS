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
    
    let groupQuestions = BehaviorRelay<[KPQuestion]>(value: []) // 선택한 그룹의 질문리스트
    
    let selectedQuestions = BehaviorRelay<[KPQuestion]>(value: []) // 선택한 질문들
    
    let groupEditMode = BehaviorRelay<Bool>(value: false) // 그룹 편집 모드 여부
    
    let selectedQuestionDetailModel = BehaviorSubject<[KPDetailModel]>.init(value:[ KPDetailModel.init(items: []) ])
    
    var keywordOnOff = BehaviorRelay<Bool>(value: true)
    
    var recordingType: RecordingType = .camera
    
    var goalPersent = BehaviorRelay<CGFloat>(value: 0)
    
    var totalPersent = BehaviorRelay<CGFloat>(value: 0)
    
    var videoURLs: [URL]?
    
    init(){
        selectedQuestions.subscribe(onNext: { items in
            self.selectedQuestionDetailModel.onNext([KPDetailModel(items: items)])
        }).disposed(by: disposeBag)
        
        groupInfo
            .map { $0?.groupQuestions.map { parsingKPQuestion($0)}}
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
