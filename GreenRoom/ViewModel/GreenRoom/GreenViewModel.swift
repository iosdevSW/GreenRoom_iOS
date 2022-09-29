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
    
    private var greenroomQuestionService = GreenRoomQuestionService()
    private var myListService = MyListService()
    private var scrapService = ScrapService()
    
    var disposeBag = DisposeBag()
    
    private let filtering = BehaviorSubject<[GreenRoomSectionModel]>(value:[] )
    private let popular = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    private let recent = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    private let greenroom = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    private let myQuestionList = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    
    struct Input {
        let greenroomTap: Observable<Void>
        let myListTap: Observable<Void>
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let greenroom: Observable<[GreenRoomSectionModel]>
    }
    
    private var dataSource = PublishSubject<[GreenRoomSectionModel]>()
    
    func transform(input: Input) -> Output {
        
        input.trigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            print("helo")
            self.fetchFiltering()
            self.fetchPopular()
            self.fetchRecent()
            self.fetchMyGreenRoom()
            self.fetchMyQuestionList()
        }).disposed(by: disposeBag)
        
        let result = Observable.combineLatest(self.filtering.asObserver() ,self.popular.asObserver(), self.recent.asObserver(), self.greenroom.asObserver() ).map { $0.0 + $0.1 + $0.2 + $0.3 }
        result.bind(to: self.dataSource).disposed(by: self.disposeBag)
        
        input.greenroomTap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            self.fetchPopular()
            self.fetchRecent()
            self.fetchMyGreenRoom()
            
            Observable.combineLatest(
                self.filtering.asObserver(),
                self.popular.asObserver(),
                self.recent.asObserver(),
                self.greenroom.asObserver()
            ).map { $0.0 + $0.1 + $0.2 + $0.3 }
                .bind(to: self.dataSource).disposed(by: self.disposeBag)
            
        }).disposed(by: self.disposeBag)
        input.myListTap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.fetchMyGreenRoom()
            self.fetchMyQuestionList()
            
            Observable.combineLatest(
                self.greenroom.asObserver(),
                self.myQuestionList.asObserver())
            .map { $0.0 + $0.1}
            .bind(to: self.dataSource).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
        
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
    
    private func fetchFiltering(){
        self.filtering.onNext([GreenRoomSectionModel.filtering(items:[ GreenRoomSectionModel.Item.filtering(interest: "디자인")])])
    }
    
    private func fetchPopular(){
        
        self.greenroomQuestionService.fetchPopularGRQuestions { [weak self] result in
            switch result {
            case.success(let popularQuestions):
                let sectionModel = GreenRoomSectionModel.popular(
                    items: popularQuestions.map { GreenRoomSectionModel.Item.popular(question: $0) })
                self?.popular.onNext([sectionModel])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchRecent(){
        self.greenroomQuestionService.fetchRecentQuestionList { [weak self] result in
            switch result {
            case.success(let recentQuestions):
                let sectionModel = GreenRoomSectionModel.recent(
                    items: recentQuestions.map { GreenRoomSectionModel.Item.recent(question: $0) })
                self?.recent.onNext([sectionModel])
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchMyGreenRoom(){
        self.greenroom.onNext([GreenRoomSectionModel.MyGreenRoom(items: [
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
        ])])
    }
    
    private func fetchMyQuestionList(){
        
        self.myListService.fetchMyQuestionList { [weak self] result in
            switch result {
            case.success(let myQuestions):
                let sectionModel = GreenRoomSectionModel.MyQuestionList(
                    items: myQuestions.map { GreenRoomSectionModel.Item.MyQuestionList(question: $0) })
                self?.myQuestionList.onNext([sectionModel])
            case .failure(let error):
                print(error)
            }
        }
        //        self.myQuestionList.onNext([GreenRoomSectionModel.MyQuestionList(items: [
        //            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
        //            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
        //            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
        //            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
        //            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
        //            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~"))
        //        ])])
    }
}

extension GreenRoomViewModel {
    
    func scrapMyQuestion(id: Int) {
        self.scrapService.updateScrapQuestion(id: id)
    }
}
