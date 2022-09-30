//
//  UIViewController+.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import UIKit

extension UIViewController {
    // 회원가입 네비게이션바 아이템 설정
    @objc func setNavigationItem() {
        let questionButtonItem = UIBarButtonItem(title: "문의사항",
                                                 style: .plain,
                                                 target: self,
                                                 action: nil)
        questionButtonItem.tintColor = .customGray
        self.navigationItem.rightBarButtonItem = questionButtonItem
    }
    
    func hideKeyboardWhenTapped(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        // 기본값이 true이면 제스쳐 발동시 터치 이벤트가 뷰로 전달x
        //즉 제스쳐가 동작하면 뷰의 터치이벤트는 발생하지 않는것 false면 둘 다 작동한다는 뜻
        view.addGestureRecognizer(tap)
        //view에 제스쳐추가
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}
