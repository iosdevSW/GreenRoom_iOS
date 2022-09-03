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

enum ImageType {
    case JPEG(image: Data)
    case PNG(image: Data)
    
    var description: String {
        switch self {
        case .JPEG(image: _):
            return "jpeg"
        case .PNG(image: _):
            return "png"
        }
    }
    
    var data: Data {
        switch self {
        case .PNG(image: let data):
            return data
        case .JPEG(image: let data):
            return data

        }
    }
}

class UserService {
    
    //MARK: - 회원정보 조회
    //    func fetchUserInfo() -> Observable<[MyPageSectionModel]> {
    //        return Observable.create { [weak self] emmiter in
    //            self?.fetchUserInfo(completion: { result in
    //                switch result {
    //                case .success(let user):
    //                    let userModel = MyPageSectionModel.profile(items: [
    //                        MyPageSectionModel.Item.profile(profileInfo: user)
    //                    ])
    //                    emmiter.onNext([userModel])
    //                case .failure(let error):
    //                    emmiter.onError(error)
    //                }
    //            })
    //            return Disposables.create()
    //        }
    //    }
    
    func fetchUserInfo() -> Observable<User> {
        let url = URL(string: Storage.baseURL + "/api/users")!
        
        return Observable.create { emitter in
            AF.request(url,interceptor: AuthManager()).validate().responseDecodable(of: User.self) { response in
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
    
    func updateProfileImage(image: UIImage?,completion:@escaping(Bool) -> Void){
        
        guard let imageData = convertImage(image: image) else { return }
        
        let param = ["profileImage": "user-profile-image.\(imageData.description)"]
        
        self.fetchPresignedURL(parameters: param) { url in
            guard let presignedURL = URL(string: url) else { return }
            self.uploadImage(imageData: imageData.data, url: presignedURL, type: imageData.description) { completed in
                completion(completed)
            }
        }
    }
    
    private func uploadImage(imageData: Data, url: URL, type: String,completion: @escaping(Bool) -> Void){
        
        let headers: HTTPHeaders = [
            "Content-Type": "image/\(type)"
        ]
        
        AF.upload(imageData, to: url, method: .put, headers: headers).response { response in
            switch response.result {
            case .success(_):
                print("DEBUG: image upload success with AWS S3")
                completion(true)
                break
            case .failure(let error):
                print("DEBUG: \(error.localizedDescription)")
                completion(false)
                break
            }
        }
    }
    
    private func fetchPresignedURL(parameters: [String: String], completion:@escaping(String) -> Void) {
        guard let url = URL(string: Storage.baseURL + "/api/users/profile-image") else {
            return
            
        }
        
        guard let accessToken = KeychainWrapper.standard.string(forKey: "accessToken") else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoder: .json, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: PresignedURL.self) { response in
            switch response.result {
            case .success(let url):
                completion(url.profileImage)
            case .failure(_):
                print("DEBUG : failure")
                break
            }
        }
    }
    
    func convertImage(image: UIImage?) -> ImageType? {
        if let jpegData = image?.jpegData(compressionQuality: 1.0) {
            print("DEBUG: convent error to PNG")
            return .JPEG(image: jpegData)
            
        } else if let pngData = image?.pngData() {
            print("DEBUG: convent error to JPEG")
            return .PNG(image: pngData)
        }
        return nil
    }
}

//MARK: - update user info
extension UserService {
    
    func updateUserInfo(parameter: [String: Any], completion: @escaping(Bool) -> Void) {
        guard let url = URL(string: Storage.baseURL + "/api/users") else { return }
        
        guard let accessToken = KeychainWrapper.standard.string(forKey: "accessToken") else {
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        if let name = parameter as? [String: String] {
            AF.request(url, method: .put,parameters: name, encoder: JSONParameterEncoder.default , headers: headers).validate(statusCode: 200..<300).response { response in
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
            AF.request(url, method: .put,parameters: category, encoder: JSONParameterEncoder.default , headers: headers).validate(statusCode: 200..<300).response { response in
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
