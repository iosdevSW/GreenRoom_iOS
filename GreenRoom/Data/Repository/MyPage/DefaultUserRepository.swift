//
//  MyPageRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import RxSwift

protocol UserRepository {
    func fetchUserInfo() -> Observable<User>
    func fetchPresignedURL(profileImage: String) -> Observable<String>
    func fetchUpload(url: String, data: Data) -> Observable<Bool>
    func updateNickname(name: String) -> Observable<Bool>
    func updateCategory(categoryId: Int) -> Observable<Bool>
}

final class DefaultUserRepository: UserRepository {
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
    
    func updateNickname(name: String) -> Observable<Bool> {
        let request = UserRequest.uploadNickname(name: name)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
    
    func updateCategory(categoryId: Int) -> Observable<Bool> {
        let request = UserRequest.uploadCategory(categoryId: categoryId)
        return NetworkManager.shared.request(with: request)
            .asObservable()
            .map { _ in true }
            .catchAndReturn(false)
    }
    
}
