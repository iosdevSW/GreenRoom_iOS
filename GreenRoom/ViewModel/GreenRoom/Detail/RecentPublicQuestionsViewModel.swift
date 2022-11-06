//
//  GRDetailViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/11.
//

import Foundation
import RxSwift

final class RecentPublicQuestionsViewModel: ViewModelType {
    
    private let repository: RecentPublicQuestionRepositoryInterface
    
    var disposeBag = DisposeBag()
    
    struct Input { }
    
    struct Output {
        let recent: Observable<[GreenRoomSectionModel]>
    }
    
    init(repository: RecentPublicQuestionRepositoryInterface) {
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        
        let recent = repository.fetchRecentPublicQuestions()
            .map { questions in
                [GreenRoomSectionModel.recent(
                    items: questions.map{ .recent(question: $0) } )
                ]
            }
        
        return Output(recent: recent)
    }
    
}
