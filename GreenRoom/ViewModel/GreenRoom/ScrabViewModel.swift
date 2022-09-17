//
//  ScrabViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/16.
//

import Foundation
import RxSwift

final class ScrapViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    
    struct Input {
        let trigger: Observable<Bool>
        let buttonTab: Observable<Void>
    }
    
    struct Output {
        let scrap: Observable<[GreenRoomSectionModel]>
    }
    
    private let recent = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    
    let selectedCategoriesObservable = BehaviorSubject<[Int]>(value: [])
    
    var selectedIndexes: [Int] = [] { 
        didSet {
            self.selectedCategoriesObservable.onNext(self.selectedIndexes)
        }
    }
    
    func transform(input: Input) -> Output {
        input.trigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.fetchRecent()
        }).disposed(by: disposeBag)
        
        input.buttonTab.subscribe(onNext: {
//            selectedIndex해당하는 것들 모두 삭제.
        }).disposed(by: disposeBag)
        return Output(scrap: self.recent.asObserver())
    }
    
}
//MARK: - API Service
extension ScrapViewModel {
    
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
}
