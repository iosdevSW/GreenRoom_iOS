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
    
    private let recent = BehaviorSubject<[GreenRoomSectionModel]>(value: [])
    
    struct Input {
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let recent: Observable<[GreenRoomSectionModel]>
    }
    
    
    func transform(input: Input) -> Output {
         
        input.trigger.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.fetchRecent()
        }).disposed(by: disposeBag)
  
        return Output(recent: self.recent.asObserver())
    }

}

//MARK: - API Service
extension GRDetailViewModel {
    
    private func fetchRecent(){
//        self.recent.onNext([GreenRoomSectionModel.recent(items: [
//            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
//            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
//            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
//            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
//            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~")),
//            GreenRoomSectionModel.Item.recent(question: Question(image: "", name: "박면접", participants: 2, category: 2, question: "하이요~"))
//        ])])
    }
}
