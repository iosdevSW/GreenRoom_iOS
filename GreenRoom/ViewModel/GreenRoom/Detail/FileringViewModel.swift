//
//  FileringViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/02.
//

import UIKit
import RxSwift

final class FilteringViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private let publicQuestionService: PublicQuestionService
    
    struct Input { }
    
    struct Output {
        let publicQuestions: Observable<[FilteringSectionModel]>
    }
    
    private let mode: FilterMode
    
    private let filteringQuestion = PublishSubject<[FilteringSectionModel]>()
    
    init(mode: FilterMode,
         publicQuestionService: PublicQuestionService) {
        self.mode = mode
        self.publicQuestionService = publicQuestionService
    }
    
    func transform(input: Input) -> Output {
        
        switch self.mode {
        case .filter(id: let id):
            self.publicQuestionService.fetchFilteredQuestion(categoryId: id)
                .map { questions in
                    [FilteringSectionModel(
                        header: Info(title: Category(rawValue: id)?.title ?? "공통",
                                 subTitle: "관련된 질문리스트를 보여드려요!\n질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)"),
                        items: questions)]
                }
                .bind(to: filteringQuestion)
                .disposed(by: disposeBag)
        case .search(keyword: let keyword):
            self.publicQuestionService.searchGreenRoomQuestion(keyword: keyword)
                .map { questions in
                    [FilteringSectionModel(
                        header: Info(title: keyword,
                                 subTitle: "관련된 질문리스트를 보여드려요!\n질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)"),
                        items: questions)]
                }
                .bind(to: filteringQuestion)
                .disposed(by: disposeBag)
        }
            
        return Output(publicQuestions: filteringQuestion.asObservable())
    }
}

