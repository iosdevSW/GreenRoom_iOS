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
    
    var goalPersent = BehaviorRelay<CGFloat>(value: 0) // 전체 질문 키워드 매칭률 목표 퍼센트
    
    var totalPersent = BehaviorRelay<CGFloat>(value: 0) // 전체 질문 키워드 매칭률 퍼센트
    
    var URLs = BehaviorRelay<[URL]>(value: []) // 녹음/녹화 URL 저장
    
    var STTResult = BehaviorRelay<[String]>(value: [])
    
    var recordingType: RecordingType = .camera // 카메라 on / off 여부
    
    var hasNextPage = BehaviorRelay<Bool>(value: false) // 다음 페이지 여부
    
    var isPaging = false //현재 페이징중인지 여부
    
    init(){
        selectedQuestions
            .subscribe(onNext: { items in
                self.selectedQuestionDetailModel.onNext([KPDetailModel(items: items)])
            }).disposed(by: disposeBag)
        
        groupInfo
            .map { $0?.groupQuestions.map { parsingKPQuestion($0) } }
            .subscribe(onNext: { [weak self] questions in
                if let questions = questions {
                    self?.groupQuestions.accept(questions)
                } else {
                    self?.groupQuestions.accept([])
                }
            })
            .disposed(by: disposeBag)
        
        groupQuestions
            .map{ (max(($0.count-1), 0) / 20)}
            .bind(onNext: { currentPage in
                guard let totalPage = self.groupInfo.value?.totalPages else { return }
                if currentPage+1 == totalPage {
                    self.hasNextPage.accept(false)
                } else {
                    self.hasNextPage.accept(true)
                }
            }).disposed(by: disposeBag)
    }
    
    func updateGroupQuestions() {
        guard let groupID = self.selectedGroupID.value else {
            groupInfo.accept(nil)
            return
        }
        
        KeywordPracticeService().fetchGroupQuestions(groupId: groupID)
            .take(1)
            .bind(to: self.groupInfo)
            .disposed(by: disposeBag)
    }
    
    func pagingGroupQuestion() {
        self.isPaging = true
        guard let groupId = self.selectedGroupID.value else {
            groupInfo.accept(nil)
            return
        }
        
        let nextPage = max((self.groupQuestions.value.count - 1), 0) / 20
        KeywordPracticeService().fetchGroupQuestions(groupId: groupId, page: nextPage+1)
            .take(1)
            .bind(onNext: { test in
                print(test.questionCnt)
            })
        KeywordPracticeService().fetchGroupQuestions(groupId: groupId, page: nextPage+1)
            .take(1)
            .map { $0.groupQuestions.map { parsingKPQuestion($0) } }
            .bind(onNext: { questions in
                var tempQuestions = self.groupQuestions.value
                tempQuestions.append(contentsOf: questions)
                self.groupQuestions.accept(tempQuestions)
                self.isPaging = false
            }).disposed(by: disposeBag)
    }
    
    func resetData() {
        self.goalPersent.accept(0)
        self.totalPersent.accept(0)
        self.URLs.accept([])
        self.STTResult.accept([])
        self.selectedQuestions.accept([])
    }
}
