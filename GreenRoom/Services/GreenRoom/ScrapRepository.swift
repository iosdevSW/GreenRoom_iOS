//
//  ScrapService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/27.
//

import Foundation
import RxSwift
import Alamofire

protocol ScrapRepositoryInterface {
    func fetchScrapQuestions() -> Observable<[GreenRoomQuestion]>
    func updateScrapQuestion(id: Int) -> Observable<Bool>
    func deleteScrapQuestion(ids: [Int]) -> Observable<Bool>
}

final class ScrapRepository: ScrapRepositoryInterface {
    
    func fetchScrapQuestions() -> Observable<[GreenRoomQuestion]> {
        let request = ScrapRequest.fetchQuestions
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: [GreenRoomQuestion].self, decoder: JSONDecoder())
    }
    
    func updateScrapQuestion(id: Int) -> Observable<Bool> {
        let request = ScrapRequest.update(id: id)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func deleteScrapQuestion(ids: [Int]) -> Observable<Bool> {
        let request = ScrapRequest.delete(ids: ids)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .map { data in
                print(data)
                return true
            }
            .catchAndReturn(false)
    }
}
