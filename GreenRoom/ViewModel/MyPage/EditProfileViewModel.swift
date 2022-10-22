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
    }

    struct Output {
        let userName: Observable<String>
    }

    var disposeBag = DisposeBag()
    
    init(userService: UserService){
        self.userService = userService
    }
    
    func transform(input: Input) -> Output {
        return Output(userName: input.trigger
            .flatMap { _ in
                self.userService.fetchUserInfo()
            }.map { $0.name })
    }
    
    func updateUserInfo(nickName: String) {
        let parameter = [
            "name" : nickName
        ]

        self.userService.updateUserInfo(parameter: parameter) { _ in
            print("업데이트에 성공했습니다.")
        }

    }
}
