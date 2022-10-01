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
    
    let selectedQuestionObservable = BehaviorSubject<[String]>.init(value: []) // 선택된 연습 질문
    
    // 그룹
    let groupsObservable = BehaviorRelay<[GroupModel]>(value: [])
    let groupCounting = PublishSubject<Int>()
    
    var selectedQ = BehaviorSubject<[KPDetailModel]>.init(value:[
        KPDetailModel.init(items: [])
    ])
    
    let tabelTemp = Observable.of(["테스트면접질문1","테스트면접질문2는 조금 긴 질문 항목입니다. 공백 포함해 35자가 넘어가면","테스트면접질문3"])
    
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
        
        groupsObservable.asObservable()
            .map{ $0.count }
            .bind(to: groupCounting)
            .disposed(by: disposeBag)
    }
    
    func updateGroupList(){
        KeywordPracticeService().fetchGroupList()
            .bind(to: groupsObservable)
            .disposed(by: disposeBag)
    }
    
}
