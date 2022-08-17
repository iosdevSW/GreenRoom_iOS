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
    
    private var profileObervable = BehaviorSubject<[MyPageSectionModel]>(value: [])
    var profileImageObservable = BehaviorSubject<UIImage?>(value:UIImage(named: "프로필이미지"))
    
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
