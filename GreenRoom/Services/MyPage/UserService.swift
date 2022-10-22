//
//  UserService.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/22.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire
import RxSwift

final class UserService {
    
    //MARK: - 회원정보 조회
    func fetchUserInfo() -> Observable<User> {
        
        return Observable.create { emitter in
            AF.request(Constants.baseURL + "/api/users",
                       interceptor: AuthManager())
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    UserDefaults.standard.set(user.categoryID, forKey: "CategoryID")
                    emitter.onNext(user)
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

//MARK: - /api/users/profile-image
extension UserService {
    
    func updateProfileImage(image: UIImage?) -> Single<Bool> {
        guard let imageData = convertImage(image: image) else { return Single.just(false) }
        
        let param = ["profileImage": "user-profile-image.\(imageData.description)"]
        
        return self.fetchPresignedURL(parameters: param)
            .flatMap { self.uploadImage(url: $0, imageData: imageData.data) }
    }
    
    private func uploadImage(url: String, imageData: Data) -> Single<Bool> {
        
        return Single.create { emitter in
            AF.upload(imageData, to: url, method: .put).response { response in
                switch response.result {
                case .success(_):
                    print("DEBUG: image upload success with AWS S3")
                    emitter(.success(true))
                case .failure(let error):
                    emitter(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func fetchPresignedURL(parameters: [String: String]) -> Single<String> {
        return Single.create { emitter in
            AF.request(Constants.baseURL + "/api/users/profile-image",
                       method: .put,
                       parameters: parameters,
                       encoder: .json,
                       interceptor: AuthManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: PresignedURL.self) { response in
                switch response.result {
                case .success(let url):
                    emitter(.success(url.profileImage))
                case .failure(let error):
                    emitter(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    private func convertImage(image: UIImage?) -> ProfileImageType? {
        if let jpegData = image?.jpegData(compressionQuality: 1.0) {
            print("jpegData")
            return .JPEG(image: jpegData)
            
        } else if let pngData = image?.pngData() {
            print("DEBUG: convent error to JPEG")
            return .PNG(image: pngData)
        } else {
            print("nil")
            return nil
        }
        
    }
}

//MARK: - update user info
extension UserService {
    
    func updateUserInfo(parameter: [String: Any], completion: @escaping(Bool) -> Void) {
        guard let url = URL(string: Constants.baseURL + "/api/users") else { return }
        
        if let name = parameter as? [String: String] {
            AF.request(url, method: .put,parameters: name, encoder: JSONParameterEncoder.default, interceptor: AuthManager()).validate(statusCode: 200..<300).response { response in
                switch response.result {
                case .success(_):
                    print("Success to upload user info")
                    completion(true)
                case .failure(let error):
                    completion(false)
                    print(error.localizedDescription)
                }
                
            }
        } else if let category = parameter as? [String: Int] {
            AF.request(url, method: .put,parameters: category, encoder: JSONParameterEncoder.default, interceptor: AuthManager()).validate(statusCode: 200..<300).response { response in
                switch response.result {
                case .success(_):
                    print("Success to upload user info")
                    completion(true)
                case .failure(let error):
                    completion(false)
                    print(error.localizedDescription)
                }
                
            }
        }
        
    }
}
