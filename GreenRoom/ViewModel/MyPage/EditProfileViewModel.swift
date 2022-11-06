//
//  EditProfileViewModel.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/03.
//

import RxSwift

final class EditProfileViewModel: ViewModelType {

    private let repository: EditProfileRepositoryInterface
    
    struct Input{
        let trigger: Observable<Bool>
        let logout: Observable<Bool>
    }

    struct Output {
        let userName: Observable<String>
        let logOutState: Observable<Bool>
    }

    var disposeBag = DisposeBag()
    private let name: String
    
    init(name: String, repository: EditProfileRepositoryInterface){
        self.name = name
        self.repository = repository
    }
    
    func transform(input: Input) -> Output {
        
        let logout = input.logout
            .flatMap { flag in
                return AuthService.shared.logout()
            }
        return Output(userName: .just(self.name), logOutState: logout)
    }
    
    func updateUserInfo(nickName: String) {
        self.repository.updateNickname(name: nickName)
            .subscribe(onNext: { _ in
                print("업데이트에 성공했습니다.")
            }).disposed(by: disposeBag)
    }
}
