//
//  MyPageViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import UIKit
import RxSwift

class MyPageViewModel {
    
    private var disposeBag = DisposeBag()
    
    //MARK: - MyPageViewController
    private var profileObervable = BehaviorSubject<[MyPageSectionModel]>(value: [])
    var profileImageObservable = BehaviorSubject<UIImage?>(value:UIImage(named: "ProfileSample"))
    var MyPageDataSource = BehaviorSubject<[MyPageSectionModel]>(value:[])
    
    private let settingsObservable = Observable<[MyPageSectionModel]>.create { observer in
        observer.onNext(
            [
                MyPageSectionModel.setting(header: "사용자 설정", items: [
                    MyPageSectionModel.SectionItem.setting(settingInfo:InfoItem(iconImage: UIImage(named: "notification"), title: "알림 설정", setting: .notification)),
                    MyPageSectionModel.SectionItem.setting(settingInfo:InfoItem(iconImage: UIImage(named: "language"), title: "면접 언어 설정", setting: .language)),
                    MyPageSectionModel.SectionItem.setting(settingInfo:InfoItem(iconImage: UIImage(named: "interest"), title: "관심 직무 설정", setting: .interest))
                ]),
                MyPageSectionModel.setting(header: "기타", items: [
                    MyPageSectionModel.SectionItem.setting(settingInfo:InfoItem(iconImage: UIImage(named: "invitation"), title: "친구 초대", setting: .invitation)),
                    MyPageSectionModel.SectionItem.setting(settingInfo:InfoItem(iconImage: UIImage(named: "version")!, title: "면접 버전", setting: .version))]),
                MyPageSectionModel.setting(header: "문의", items: [
                    MyPageSectionModel.SectionItem.setting(settingInfo:InfoItem(iconImage: UIImage(named: "FAQ")!, title: "FAQ", setting: .FAQ)),
                    MyPageSectionModel.SectionItem.setting(settingInfo:InfoItem(iconImage: UIImage(named: "QNA")!, title: "직접 문의", setting: .QNA))])])
        return Disposables.create()
    }
    
    
    //MARK: - QNAViewController
    private let defaultQNAImage = Observable<UIImage?>.create { observer in
        observer.onNext(UIImage(systemName: "plus.circle"))
        return Disposables.create()
    }
    
    //MARK: - FAQ
    var shownFAQ = BehaviorSubject<[FAQ]>(value: [])
    
    var presetFAQ: [FAQ] = [
        FAQ(question: "이 어플은 누구를 위해 만들어졌나요?",
            answer: "예시답변1입니다,예시답변1입니다예시답변1입니다,예시답변1입니다,예시답변1입니다,예시답변1입니다,예시답변1입니다,예시답변1입니다,예시답변1입니다,예시답변1입니다,예시답변1입니다,예시답변1입니다"),
        FAQ(question: "면접 질문은 누구나 만들 수 있나요?", answer: "answer2"),
        FAQ(question: "언어설정은 어떻게 하나요?", answer: "answer3"),
        FAQ(question: "면접 초보자도 이용할 수 있나요?", answer: "answer4"),
        FAQ(question: "무성의한 답변을 단 사람은 어떻게 하나요?", answer: "answer5"),
        FAQ(question: "면접이 너무 부담스러운데 어떡하죠?", answer: "answer6")
    ]
    
    init(){
        bind()
    }
    
    func bind(){
        
        let userName = "정해성"
        let email = "Greenroom@gmail.com"
        
        profileImageObservable.subscribe(onNext: { [weak self] profileImage in
            let profile = MyPageSectionModel.profile(items: [MyPageSectionModel.SectionItem.profile(profileInfo: ProfileItem(profileImage: profileImage, nameText: userName, emailText: email))])
            self?.profileObervable.onNext([profile])
        }).disposed(by: disposeBag)

        Observable.combineLatest(profileObervable.asObserver(), settingsObservable.asObservable()).subscribe(onNext: { [weak self] datasource in
            self?.MyPageDataSource.onNext(datasource.0 + datasource.1)
        }).disposed(by: disposeBag)
    }
}
