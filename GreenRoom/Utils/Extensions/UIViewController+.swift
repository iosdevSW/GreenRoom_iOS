//
//  UIViewController+.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/26.
//

import UIKit
import RxSwift

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
    
    func showAlert(title : String, message: String? = nil) -> Observable<Bool> {
        
        return Observable.create { [weak self] observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.overrideUserInterfaceStyle = .light
            alertController.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                observer.onNext(true)
            })
            alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            self?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showGuideAlert(title : String, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = .light
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: handler))
        
        self.present(alertController, animated: true)
    }
    
    /// 강조( 레이블 색다르게하기 )
    func setColorHilightAttribute(text: String, hilightString: String, color: UIColor) -> NSMutableAttributedString {
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: hilightString))
        
        return attributedStr
    }
}
