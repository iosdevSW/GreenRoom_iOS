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
    
    var keywordOnOff = BehaviorRelay<Bool>(value: true) // 키워드 On / Off 여부
    
    var recordingType: RecordingType = .camera // 카메라 on / off 여부
    
    var goalPersent = BehaviorRelay<CGFloat>(value: 0) // 전체 질문 키워드 매칭률 목표 퍼센트
    
    var totalPersent = BehaviorRelay<CGFloat>(value: 0) // 전체 질문 키워드 매칭률 퍼센트
    
    var URLs = BehaviorRelay<[URL]>(value: []) // 녹음/녹화 URL 저장
    
    var STTResult = BehaviorRelay<[String]>(value: [])
    
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
    
    func resetData() {
        self.goalPersent.accept(0)
        self.totalPersent.accept(0)
        self.selectedQuestions.accept([])
    }
}
