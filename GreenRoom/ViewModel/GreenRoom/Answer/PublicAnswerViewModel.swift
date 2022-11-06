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
    
    private let detailGreenRoomRepository: DetailGreenRoomRepositoryInterface
    private let scrapRepository: ScrapRepositoryInterface
    
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
    
    private let scrapStateObservable = BehaviorSubject<Bool>(value: false)
    private let detailPublicAnswer = PublishSubject<PublicAnswerList>()
    
    private let failMessage = PublishRelay<String>()
    private let successMessage = PublishRelay<String>()
    
    let id: Int
    
    init(id: Int, scrapRepository: ScrapRepositoryInterface, detailGreenRoomRepository: DetailGreenRoomRepositoryInterface){
        self.id = id
        self.scrapRepository = scrapRepository
        self.detailGreenRoomRepository = detailGreenRoomRepository
    }
    
    func transform(input: Input) -> Output {
        
        detailGreenRoomRepository
            .fetchDetailPublicQuestion(id: id)
            .withUnretained(self)
            .subscribe(onNext: { onwer, question in
                onwer.scrapStateObservable.onNext(question.question.scrap)
                onwer.detailPublicAnswer.onNext(question)
            }).disposed(by: disposeBag)
        
        input.scrapButtonTrigger
            .withLatestFrom(scrapStateObservable)
            .withUnretained(self)
            .flatMap { onwer, state in
                state ? onwer.scrapRepository.deleteScrapQuestion(ids: [onwer.id]) : onwer.scrapRepository.updateScrapQuestion(id: onwer.id)
            }
            .bind(to: scrapStateObservable)
            .disposed(by: disposeBag)
        
        let output = detailPublicAnswer.map { detailPublicAnswer in
            return PublicAnswerSectionModel(header: detailPublicAnswer.question, items: detailPublicAnswer.answers)
        }
        
        return Output(answer: output, scrapUpdateState: scrapStateObservable.asObservable())
    }
}
