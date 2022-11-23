//
//  EditProfileRepository.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/06.
//

import Foundation
import RxSwift

protocol EditProfileRepositoryInterface {
    func updateNickname(name: String) -> Observable<Bool>
    func updateCategory(categoryId: Int) -> Observable<Bool>
}

final class EditProfileRepository: EditProfileRepositoryInterface {
    
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
