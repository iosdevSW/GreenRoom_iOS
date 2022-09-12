//
//  GRDetailViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/11.
//

import Foundation
import RxSwift

final class GRDetailViewModel: ViewModelType {
    
    private var greenroomService = GreenRoomService()
    
    var disposeBag = DisposeBag()
    
    private let filtering = BehaviorSubject<[GreenRoomSectionModel]>(value:[])
    private let popular = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    private let recent = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    private let greenroom = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    private let myQuestionList = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    
    struct Input {
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let greenroom: Observable<[GreenRoomSectionModel]>
    }
    
    private var dataSource = PublishSubject<[GreenRoomSectionModel]>()
    private var GRDataSource = PublishSubject<[GreenRoomSectionModel]>()
    private var myListDataSource = PublishSubject<[GreenRoomSectionModel]>()
    
    func transform(input: Input) -> Output {
         
        input.trigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.fetchFiltering()
            self.fetchPopular()
            self.fetchRecent()
            self.fetchMyGreenRoom()
            self.fetchMyQuestionList()
        }).disposed(by: disposeBag)
        
        let result = Observable.combineLatest(self.filtering.asObserver() ,self.popular.asObserver(), self.recent.asObserver(), self.greenroom.asObserver() ).map { $0.0 + $0.1 + $0.2 + $0.3 }
        result.bind(to: self.dataSource).disposed(by: self.disposeBag)
        
//        input.greenroomTap.subscribe(onNext: { [weak self] _ in
//            guard let self = self else { return }
//
//            Observable.combineLatest(
//                self.filtering.asObserver(),
//                self.popular.asObserver(),
//                self.recent.asObserver(),
//                self.greenroom.asObserver()
//            ).map { $0.0 + $0.1 + $0.2 + $0.3 }
//                .bind(to: self.dataSource).disposed(by: self.disposeBag)
//
//        }).disposed(by: self.disposeBag)
//        input.myListTap.subscribe(onNext: { [weak self] _ in
//            guard let self = self else { return }
//
//            Observable.combineLatest(
//                self.greenroom.asObserver(),
//                self.myQuestionList.asObserver())
//            .map { $0.0 + $0.1}
//            .bind(to: self.dataSource).disposed(by: self.disposeBag)
//
//        }).disposed(by: disposeBag)

        return Output(greenroom: self.dataSource.asObserver())
    }
    
    let currentBannerPage = PublishSubject<Int>()

}

//MARK: - API Service
extension GRDetailViewModel {
    
    private func fetchFiltering(){
        self.filtering.onNext([GreenRoomSectionModel.filtering(items:[ GreenRoomSectionModel.Item.filtering(interest: "디자인")])])
    }
    
    private func fetchPopular(){
        self.popular.onNext([GreenRoomSectionModel.popular(items: [
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~"))
        ])])
    }
    
    private func fetchRecent(){
        self.recent.onNext([GreenRoomSectionModel.recent(items: [
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~"))
        ])])
    }
    
    private func fetchMyGreenRoom(){
        self.greenroom.onNext([GreenRoomSectionModel.MyGreenRoom(items: [
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
        ])])
    }
    
    private func fetchMyQuestionList(){
        self.myQuestionList.onNext([GreenRoomSectionModel.MyQuestionList(items: [
            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyQuestionList(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~"))
        ])])
    }
}
