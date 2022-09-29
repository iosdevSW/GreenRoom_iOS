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

class GreenRoomViewModel: ViewModelType {
    
    enum GreenRoomMode: Int {
        case GreenRoom = 0
        case MyList
    }
    
    private var greenroomQuestionService = GreenRoomQuestionService()
    private var myListService = MyListService()
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let greenroomTap: Observable<Void>
        let myListTap: Observable<Void>
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let greenroom: Observable<[GreenRoomSectionModel]>
    }
    
    private var mode = BehaviorSubject<GreenRoomMode>(value: .GreenRoom)
    private var dataSource = PublishSubject<[GreenRoomSectionModel]>()
    
    func transform(input: Input) -> Output {

        input.trigger.withLatestFrom(mode).flatMap { mode in
            return mode == .GreenRoom ? self.fetchGreenRoomTap() : self.fetchMyListsTap()
        }.bind(to: self.dataSource).disposed(by: disposeBag)
        
        input.greenroomTap
            .subscribe(onNext: {
                self.mode.onNext(.GreenRoom)
            }).disposed(by: disposeBag)
        
        input.myListTap
            .subscribe(onNext: { _ in
                self.mode.onNext(.MyList)
            }).disposed(by: disposeBag)    
        
        input.greenroomTap.asObservable()
            .flatMap { self.fetchGreenRoomTap() }
            .bind(to: self.dataSource)
            .disposed(by: disposeBag)

        input.myListTap.asObservable()
            .flatMap { self.fetchMyListsTap() }
            .bind(to: self.dataSource)
            .disposed(by: self.disposeBag)
        
        

        return Output(greenroom: self.dataSource.asObserver())
    }
    
    let currentBannerPage = PublishSubject<Int>()
    
    func isLogin()->Observable<Bool> {
        if let accessToken = KeychainWrapper.standard.string(forKey: "accessToken"){
            return Observable.create{ emitter in
                //accessToken 유효성 체크 부분, 유효하면 true
                // 유효하지 않으면 refreshtoken통해 재발급
                // refreshtoken도 유효하지 않으면 false
                // 일단 유효성 체크 API가 없어서 있으면 넘어가는 것만 구현
                emitter.onNext(true)
                return Disposables.create()
            }
            
        }else {
            return Observable.create{ emitter in
                emitter.onNext(false)
                emitter.onCompleted()
                
                return Disposables.create()
            }
        }
    }
}

//MARK: - API Service
extension GreenRoomViewModel {
    
    private func fetchGreenRoomTap() -> Observable<[GreenRoomSectionModel]>{
        
        let popuplar = self.greenroomQuestionService.fetchPopularPublicQuestions().map{ questions in
            [GreenRoomSectionModel.popular(items: questions.map { GreenRoomSectionModel.Item.popular(question: $0)})]
        }
        
        let recent = self.greenroomQuestionService.fetchRecentPublicQuestions().map { questions in
            [GreenRoomSectionModel.recent(items: questions.map { GreenRoomSectionModel.Item.recent(question: $0)})]
        }
        
        return Observable.zip(self.fetchFiltering(), popuplar, recent, self.fetchMyGreenRoom()).map { $0.0 + $0.1 + $0.2 + $0.3 }
    }
    
    private func fetchMyListsTap() -> Observable<[GreenRoomSectionModel]> {
        let greenRoom = self.fetchMyGreenRoom()
        
        let mylistQuestions = self.myListService.fetchPrivateQuestions().map { questions in
            [GreenRoomSectionModel.MyQuestionList(items: questions.map { GreenRoomSectionModel.Item.MyQuestionList(question: $0)})]
        }
        
        return Observable.zip(greenRoom, mylistQuestions).map{ $0.0 + $0.1 }
        
    }
    private func fetchFiltering() -> Observable<[GreenRoomSectionModel]>{
        return Observable.create { emitter in
            emitter.onNext([GreenRoomSectionModel.filtering(items:[ GreenRoomSectionModel.Item.filtering(interest: "디자인")])])
            return Disposables.create()
        }
    }
    
    private func fetchMyGreenRoom() -> Observable<[GreenRoomSectionModel]>{
        return Observable<[GreenRoomSectionModel]>.of([GreenRoomSectionModel.MyGreenRoom(items: [
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
        ])])
    }
}
