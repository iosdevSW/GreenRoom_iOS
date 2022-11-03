//
//  EditProfileViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/03.
//

import RxSwift

final class EditProfileViewModel: ViewModelType {

    private let userService: UserService
    
    struct Input{
        let trigger: Observable<Bool>
        let logout: Observable<Bool>
    }

    struct Output {
        let userName: Observable<String>
        let logOutState: Observable<Bool>
    }

    var disposeBag = DisposeBag()
    
    init(userService: UserService){
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        
        let logout = input.logout
            .flatMap { flag in
                return AuthService.shared.logout()
            }
        let userName = input.trigger
            .withUnretained(self)
            .flatMap { onwer, _ in
                onwer.userService.fetchUserInfo()
            }.map { $0.name }
        
        return Output(userName: userName, logOutState: logout)
    }
    
    func updateUserInfo(nickName: String) {
        let parameter = [ "name" : nickName ]

        self.userService.updateUserInfo(parameter: parameter) { _ in
            print("업데이트에 성공했습니다.")
        }

    }
}
