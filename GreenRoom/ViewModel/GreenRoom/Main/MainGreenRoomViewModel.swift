//
//  GreenViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import SwiftKeychainWrapper
import RxSwift
import RxCocoa

class MainGreenRoomViewModel: ViewModelType {
    
    enum GreenRoomMode: Int {
        case GreenRoom = 0
        case MyList
    }
    
    private let greenRoomRepositry: MainGreenRoomRepositoryInferface
//    private var publicQuestionService = PublicQuestionService()
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let mainStatus: Observable<Int>
        let nextButtonTrigger: Observable<Void>
        let prevButtonTrigger: Observable<Void>
    }
    
    struct Output {
        let greenroom: Observable<[GreenRoomSectionModel]>
    }
    
    let currentBannerPage = PublishSubject<Int>()
    private var mode = BehaviorSubject<GreenRoomMode>(value: .GreenRoom)
    private var dataSource = PublishSubject<[GreenRoomSectionModel]>()
    private var currentPage = BehaviorRelay<Int>(value: 0)

    private let myGreenRoom = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    
    init(greenRoomRepositry: MainGreenRoomRepositoryInferface) {
        self.greenRoomRepositry = greenRoomRepositry
    }
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .withLatestFrom(mode)
            .withUnretained(self)
            .flatMap { onwer, mode in
                return onwer.layoutUpdate(with: mode.rawValue)
            }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        input.mainStatus
            .compactMap { GreenRoomMode(rawValue: $0) }
            .bind(to: mode)
            .disposed(by: disposeBag)
        
        input.nextButtonTrigger
            .withUnretained(self)
            .map({ onwer, _ in
                return onwer.currentPage.value + 1
            })
            .bind(to: currentPage)
            .disposed(by: disposeBag)
        
        input.prevButtonTrigger
            .withUnretained(self)
            .map({ owner, _ in
                return owner.currentPage.value - 1
            })
            .bind(to: currentPage)
            .disposed(by: disposeBag)
        
        self.mode
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .flatMap { $0.layoutUpdate(with: $1.rawValue) }
            .bind(to: dataSource)
            .disposed(by: disposeBag)
        
        self.currentPage
            .withUnretained(self)
            .flatMap { $0.fetchMyGreenRoom(page: $1) }
            .bind(to: myGreenRoom)
            .disposed(by: disposeBag)
        
        return Output(greenroom: self.dataSource.asObserver())
    }
}

//MARK: - API Service
extension MainGreenRoomViewModel {
    
    /// 뷰의 상태를 업데이트
    func layoutUpdate(with mode: Int) -> Observable<[GreenRoomSectionModel]> {
        return mode == 0 ? self.fetchGreenRoomTap() : fetchMyListsTap()
    }
    
    /// 그린룸탭
    private func fetchGreenRoomTap() -> Observable<[GreenRoomSectionModel]>{
        
        return Observable.combineLatest(
            self.fetchFiltering(),
            self.fetchPopular(),
            self.fetchRecent(),
            self.myGreenRoom.asObservable())
        .map { $0.0 + $0.1 + $0.2 + $0.3 }
    }
    
    ///마이리스트 탭
    private func fetchMyListsTap() -> Observable<[GreenRoomSectionModel]> {

        return Observable.combineLatest(
            self.myGreenRoom.asObservable(), fetchMyList()
        ).map{ $0.0 + $0.1 }
    }
    
    ///최근 필터링 뷰
    private func fetchFiltering() -> Observable<[GreenRoomSectionModel]>{
        
        let categoryId = Category(rawValue: UserDefaults.standard.integer(forKey: "CategoryID")) ?? .common
        
        return .just([.filtering(items:[.filtering(interest: categoryId)])])
    }
    
    /// 인기 질문
    private func fetchPopular() -> Observable<[GreenRoomSectionModel]> {
        
        return self.greenRoomRepositry
            .fetchPopularPublicQuestions()
            .map { questions in
                [GreenRoomSectionModel.popular(
                    items: questions.map { .popular(question: $0) }
                )]
            }
    }
    
    ///최근 질문
    private func fetchRecent() -> Observable<[GreenRoomSectionModel]> {
        
        return self.greenRoomRepositry
            .fetchRecentPublicQuestions()
            .map { questions in
                [GreenRoomSectionModel.recent(items: questions.map { GreenRoomSectionModel.Item.recent(question: $0)})]
            }
    }
    
    /// 내가 작성한 그린룸
    private func fetchMyGreenRoom(page: Int) -> Observable<[GreenRoomSectionModel]>{
        
        return self.greenRoomRepositry
            .fetchOwnedPublicQuestions(page: page)
            .map { question in
                [GreenRoomSectionModel.MyGreenRoom(items: [GreenRoomSectionModel.Item.MyGreenRoom(question: question)])]
            }
    }
    
    /// 내가 작성한 질문
    private func fetchMyList() -> Observable<[GreenRoomSectionModel]> {
        return self.greenRoomRepositry
            .fetchPrivateQuestions()
            .map { questions in
                [GreenRoomSectionModel.MyQuestionList(items: questions.map { .MyQuestionList(question: $0)})]
            }
    }
}
