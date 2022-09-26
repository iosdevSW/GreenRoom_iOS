//
//  QuestionService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper
import RxSwift
import RxCocoa


enum QuestionError: Error, LocalizedError {
    case exceedMaximumLength
    case invalidCategory
    
    public var errorDescription: String? {
        switch self {
        case .exceedMaximumLength:
            return NSLocalizedString("질문의 길이는 50자 이하여야 합니다.", comment: "exceedMaximumLength")
        case .invalidCategory:
            return NSLocalizedString("지원하는 카테고리가 아닙니다", comment: "invalidCategory")
        }
    }
}

final class QuestionService {
//completion: @escaping(Result<Bool, Error>) -> Void
    func uploadQuestionList(categoryId: Int, question: String) -> Observable<Bool> {
        
        print("DEBUG: \(categoryId),, \(question)")
        let url = URL(string: "\(Constants.baseURL)/api/private-questions")!
        
        let parameters = UploadQuestionModel(categoryId: categoryId, question: question)
        
        return Observable.create { emitter in
            AF.request(url, method: .post, parameters: parameters, encoder: .json, interceptor: AuthManager()).responseData { response in
                switch response.result {
                case .success(_):
                    if response.response?.statusCode == 400 {
                        emitter.onError(QuestionError.exceedMaximumLength)
                    } else if response.response?.statusCode == 404 {
                        emitter.onError(QuestionError.invalidCategory)
                    } else {
                        emitter.onNext(true)
                    }
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
        
    }
}
