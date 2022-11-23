//
//  MyPageRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import RxSwift

protocol MyPageRepositoryInterface {
    func fetchUserInfo() -> Observable<User>
    func fetchPresignedURL(profileImage: String) -> Observable<String>
    func fetchUpload(url: String, data: Data) -> Observable<Bool>
}

final class MyPageRepository: MyPageRepositoryInterface {
    func fetchUserInfo() -> Observable<User> {
        let request = UserRequest.userInfo
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: User.self, decoder: JSONDecoder())
    }
    
    func fetchPresignedURL(profileImage: String) -> Observable<String> {
        let request = UserRequest.presignedURL(profileImage: profileImage)

        return NetworkManager.shared.request(with: request)
            .asObservable()
            .decode(type: PresignedURL.self, decoder: JSONDecoder())
            .map(\.profileImage)
    }
    
    func fetchUpload(url: String, data: Data) -> Observable<Bool> {
        return NetworkManager.shared.upload(url: url, data: data)
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
    
}
