//
//  AnswerViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/22.
//

import Foundation
import RxSwift

final class AnswerViewModel: ViewModelType {
    
    private let myListService = MyListService()
    var disposeBag = DisposeBag()
    
    struct Input {
        let trigger: Observable<Bool>
    }
    
    struct Output {
        let answer: Observable<Answer>
    }
    
    let answer = BehaviorSubject<Answer>(value: Answer(answer:
                                                            """
                                                         앞서 말한 것과 같이 이미 있는 제품의 디자인을 제 시각으로 새롭게 바꾸는 실험을 해보았습니다. 지루한 제품 설명서를 새로 편집해보거나, 명함을 만들어보기도 하고, 좋아하는 브랜드를 정해서 그 브랜드의 철학, 이야기, 가치 등을 이해한 후, 그에 맞는 이미지를 찾아 새로운 배열과 그리드를 이용하여 브랜드 매뉴얼을 만들어 보기도 했습니다. 단편적인 시각물로 사람들과 소통하는 것은 어려운 일이지만 그럼에도 불구하고 깊은 울림과 감동을 주는 디자이너가 될 수 있도록 꾸준한 실험을 통해 발전하고 성장하겠습니다.
                                                         """,
                                                keywords: ["새롭게 바꾸는 실험","브랜드 매뉴얼", "꾸준한 실험"])
    )
    
    let placeholder = """
                        나와 같은 동료들은 어떤 답변을 줄까요?
                        *부적절한 멘트 사용 혹은 질문과 관련없는 답변은 삼가해주세요.
                        (그외의 내용은 자유롭게 기입해주세요)
                        *답변 가이드라인은 마이페이지>FAQ를 참고해주세요.
                        """
    
//    private var selectedKeywords: [String] = ["새롭게 바꾸는 실험", "브랜드 매뉴얼", "꾸준한 실험"] {
//        didSet { self.keywords.onNext(self.selectedKeywords) }
//    }
//
//    let keywords = BehaviorSubject<[String]>(value: ["새롭게 바꾸는 실험", "브랜드 매뉴얼", "꾸준한 실험"])
    
    let id: Int
    private var question: GreenRoomQuestion?
    
    init(id: Int){
        self.id = id
    }
    
    func transform(input: Input) -> Output {
        
//        _ = input.trigger.flatMap { check in
//            guard let self = self else { return }
//            return self.myListService.fetchMyQuestion(id: self.id)
//        }.subscribe(onNext: {
//            print($0)
//        }).disposed(by: self.disposeBag)

        return Output(answer: answer.asObservable())
    }
}
