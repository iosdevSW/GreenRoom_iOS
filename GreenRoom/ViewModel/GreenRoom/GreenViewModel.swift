//
//  GreenViewModel.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import SwiftKeychainWrapper
import RxSwift

class GreenRoomViewModel {
    private var greenroomService = GreenRoomService()
    
    var recentKeywords = BehaviorSubject<[GRSearchModel]>(value: [
        GRSearchModel.recent(header: "최근 검색어",items: [])
    ])
    
    var popularKeywords = BehaviorSubject<[GRSearchModel]>(value: [
        GRSearchModel.recent(header: "인기 검색어",items: [])
    ])
    
    let currentBannerPage = PublishSubject<Int>()
    let greenroom = BehaviorSubject<[GreenRoomSectionModel]>(value: [
        GreenRoomSectionModel.filtering(items:[ GreenRoomSectionModel.Item.filtering(interest: "디자인")]),
        GreenRoomSectionModel.popular(items: [
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.popular(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~"))
        ]),
        GreenRoomSectionModel.recent(items: [
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~"))
        ]),
        GreenRoomSectionModel.recent(items: [
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
            GreenRoomSectionModel.Item.MyGreenRoom(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~"))
        ])
    ])
    
    
    init(){
        self.bind()
    }
    
    func bind(){
        self.fetchKeywords()
    }
    
    private func fetchKeywords() {
        recentKeywords.onNext(
            [GRSearchModel.recent(header: "최근 검색어", items:
                                    CoreDataManager.shared.loadFromCoreData(request: RecentSearchKeyword.fetchRequest()).sorted {
                                        $0.date! > $1.date!
                                    }.map {
                                        SearchTagItem(text: $0.keyword!, type: .recent)
                                    })
            ]
        )
        
        
        greenroomService.fetchPopularKeywords { [weak self] result in
            switch result {
            case .success(let keywords):
                self?.popularKeywords.onNext(
                    [GRSearchModel.popular(header: "인기 검색어", items:
                                            keywords.map {
                                                GRSearchModel.Item(text: $0, type: .popular)
                                            })
                    ]
                )
            case .failure(_):
                break
            }
        }
    }
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
