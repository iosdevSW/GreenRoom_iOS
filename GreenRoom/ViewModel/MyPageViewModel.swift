//
//  MyPageViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MyPageViewModel {
    
    let userService = UserService()
    
    private var disposeBag = DisposeBag()
    
    //MARK: - MyPageViewController
//    let signal = PublishRelay<Void>()
    
    var userObservable = BehaviorSubject<[MyPageSectionModel]>(value: [])
    var profileImageObservable = PublishSubject<UIImage?>()
    var MyPageDataSource = BehaviorSubject<[MyPageSectionModel]>(value:[])
    var usernameObservable = BehaviorSubject<String>(value: "")

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
            answer: """
                    우리의 면접 과정은 무겁고 두려운 단계로 느끼고 있는 사람을 위해서 제작되었어요.
                    면접을 경험해보고 싶은 사람들도 환영해요!
                    
                    회사 면접이 아니라 동아리 면접 준비생도 언제든지 사용할 수 있어요 :)
                    """),
        FAQ(question: "면접 질문은 누구나 만들 수 있나요?",
            answer: """
                    내가 받은 면접 질문에 대해 받을 답변이 궁금한 사람, 나만의 질문을 만들어보고 싶은 사람 누구든 작성할 수 있어요!
                    단, 면접과 관련된 내용으로 작성해주세요:)
                    """),
        FAQ(question: "동료의 답변은 언제 확인할 수 있나요?",
            answer: """
                    커뮤니티 활성화를 위해 답변 공개 시간을 제한을 두었어요. 만일 답변을 남겼다면 시간 종료시 모든 동료들의 답변을 확인할 수 있습니다! 아직 답변을 남기지 않으셨다면 답변을 먼저 남겨주세요:)
                    """),
        FAQ(question: "언어설정은 어떻게 하나요?",
            answer: """
                그린룸에서는 한국어 면접 뿐만 아니라 영어 면접도 지원하고 있어요. 마이페이지>설정에서 면접 언어 설정을 통해 변경할 수 있습니다:)
                """),
        FAQ(question: "면접 시간은 어떻게 설정되어 있나요?",
            answer: "그린룸은 가벼운 면접연습을 구성하기 위해 시간제한을 두지 않았습니다. 면접이 부담스럽지 않도록 기회를 마련해드릴게요!"),
        FAQ(question: "면접 답변은 어떻게 달면 되나요?(가이드라인)",
            answer: """
                    모든 답변자는 가이드라인에 벗어나지 않는 내용에서 자유로이 답변 작성이 가능합니다. 최대한 성의있고 꼼꼼하게 작성하면 면접 답변에 좋은 경험이 될 거예요!
                    
                    1. 질문과 관련이 없는 콘텐츠가 포함된 답변은 삼가해주세요.
                    2. 모든 종류의 상업 또는 홍보 콘텐츠를 포함하는 답변은 삼가해주세요.
                    3. 외설적이거나 위협적인 글, 편견, 편파적인 발언은 삼가해주세요.
                    4. 개인이 식별할 수 있는 개인 정보(이름, 주소, 전화번호 등)은 삼가해주세요.
                    5. 법률적으로 오해의 수지가 될 수 있는 답변 내용은 자제해주세요.
                    6. 타인의 답변을 베껴 작성하는 행위는 삼가해주세요.
                    """)
    ]
    init(){
        self.bind()
    }
    func bind(){
        loadUserInfo()
        
        profileImageObservable.subscribe(onNext: { [weak self] image in
            self?.userService.updateProfileImage(image: image) { completeUpload in
                if completeUpload {
                    self?.loadUserInfo()
                }
                
            }
        }).disposed(by: disposeBag)
        
    
        Observable.combineLatest(userObservable.asObserver(), settingsObservable.asObservable())
            .subscribe(onNext: { [weak self] datasource in
            self?.MyPageDataSource.onNext(datasource.0 + datasource.1)
        }).disposed(by: disposeBag)
    }
    
    //MARK: - fetchUserinfo
    private func loadUserInfo(){
        
        self.userService.fetchUserInfo() { [weak self] result in
            switch result {
            case .success(let user):
                
                UserDefaults.standard.set(user.categoryID, forKey: "CategoryID")
                
                let userModel = MyPageSectionModel.profile(items: [
                    MyPageSectionModel.Item.profile(profileInfo: user)
                ])
                self?.usernameObservable.onNext(user.name)
                self?.userObservable.onNext([userModel])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - update user info
    func updateUserInfo(nickName: String? = nil, cateogryId: Int? = nil) {
        var parameter: [String: Any] = [:]
        
        if let nickName = nickName {
            parameter["name"] = nickName
        }
        
        if let cateogryId = cateogryId {
            parameter["categoryId"] = cateogryId
        }
        
        self.userService.updateUserInfo(parameter: parameter) { [weak self] isCompleted in
            if isCompleted {
                self?.loadUserInfo()
            }
            
        }

    }
}


