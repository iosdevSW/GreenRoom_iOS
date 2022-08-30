//
//  CreateViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import Foundation
import RxSwift

final class CreateViewModel {
    
    let categories = Observable.of(["공통","인턴","대외활동","디자인","경영기획","회계","생산/품질관리","인사","마케팅","영업","IT/개발","연구개발(R&D)"])
    
    let questionObserver = BehaviorSubject<String>(value: "")
    let selectedCategoryObserver = BehaviorSubject<Int>(value: -1)
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(questionObserver, selectedCategoryObserver)
            .map { text, category in
                return !text.isEmpty && text != "면접자 분들은 나에게 어떤 질문을 줄까요?" && category != -1
            }
    }
}
