////
////  PublicAnswerViewModel.swift
////  GreenRoom
////
////  Created by Doyun Park on 2022/10/03.
////
//
import Foundation
import RxSwift
import RxCocoa

final class PublicAnswerViewModel: ViewModelType {
    
    private let publicQuestionService: PublicQuestionService
    private let scrapService: ScrapService
    
    var disposeBag = DisposeBag()
    
    /** 스크랩, 그린룸 등록, 답변 작성, 키워드 작성, 완성 버튼*/
    struct Input {
        let scrapButtonTrigger: Observable<Void>
        let registerGreenRoomTrigger: Observable<Void>
    }
    
    struct Output {
        let answer: Observable<PublicAnswerSectionModel>
        let scrapUpdateState: Observable<Bool>
    }
    
    private let textFieldContentObservable = BehaviorSubject<String>(value: "")
    private let scrapStateObservable = BehaviorSubject<Bool>(value: false)
    private let detailPublicAnswer = PublishSubject<PublicAnswerList>()
    
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let id: Int
    
    init(id: Int, scrapService: ScrapService, publicQuestionService: PublicQuestionService){
        self.id = id
        self.scrapService = scrapService
        self.publicQuestionService = publicQuestionService
    }
    
    func transform(input: Input) -> Output {
        
        publicQuestionService.fetchDetailPublicQuestion(id: id)
            .subscribe(onNext: { [weak self] question in
                self?.scrapStateObservable.onNext(question.question.scrap)
                self?.detailPublicAnswer.onNext(question)
            }).disposed(by: disposeBag)
        
        input.scrapButtonTrigger.withLatestFrom(scrapStateObservable)
            .flatMap { state in
                return state ? self.scrapService.deleteScrapQuestion(ids: [self.id]) : self.scrapService.updateScrapQuestion(id: self.id)
            }.bind(to: scrapStateObservable)
            .disposed(by: disposeBag)
        
        let output = detailPublicAnswer.map { detailPublicAnswer in
            return PublicAnswerSectionModel(header: detailPublicAnswer.question, items: detailPublicAnswer.answers)
        }
        
        return Output(answer: output, scrapUpdateState: scrapStateObservable.asObservable())
    }
}
