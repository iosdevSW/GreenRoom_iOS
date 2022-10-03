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
    
    let selectedGroupID = BehaviorRelay<Int?>(value: nil)
    
    let groupInfo = BehaviorRelay<GroupQuestionModel?>(value: nil)
    
    let groupQuestions = BehaviorRelay<[GroupQuestion]>(value: [])
    
    let selectedQuestionObservable = BehaviorSubject<[String]>.init(value: []) // 선택된 연습 질문

    var selectedQ = BehaviorSubject<[KPDetailModel]>.init(value:[
        KPDetailModel.init(items: [])
    ])
    
    var selectedQuestionTemp = [String]() {
        didSet{
            selectedQuestionObservable.onNext(self.selectedQuestionTemp)
        }
    }
    
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
