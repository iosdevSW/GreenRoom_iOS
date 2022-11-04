//
//  Provider.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/04.
//

import Foundation
import RxSwift
import Alamofire

protocol Provider {
    func request(with request: EndPoint) -> Single<Data>
}

final class NetworkManager: Provider {
    
    static let shared = NetworkManager()
    
    private init () { }
    
    func request(with request: EndPoint) -> Single<Data> {
        return Single.create { single in
        
            guard let AFRequest = request.getRequest() else { return Disposables.create() }
            AFRequest
                .validate(statusCode: 200..<300)
                .responseData(completionHandler: { response in
                    print(response)
                switch response.result {
                case .success(let result):
                    single(.success(result))
                case .failure(let error):
                    print(error.localizedDescription)
                    single(.failure(error))
                }
            })
            return Disposables.create()
        }
    }
    
    /**
     data와 http status코드를 확인
     URLSession에서 나온 data, response, error를 파라미터로 가짐.
     */
    private func verify(data: Data?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Data, Error> {
        
        switch urlResponse.statusCode {
        case 200...299:
            if let data = data {
                return .success(data)
            } else {
                return .failure(APIError.unknown)
            }
        case 400...499:
            return .failure(APIError.badRequest(error?.localizedDescription))
        case 500...599:
            return .failure(APIError.serverError(error?.localizedDescription))
        default:
            return .failure(APIError.unknown)
        }
    }
}
