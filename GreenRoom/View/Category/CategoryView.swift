//
//  CategoryView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class CategoryView: UICollectionView {
    let title = Observable.of(["공통","인턴","대외활동","디자인","경영기획","회계","생산/품질관리","인사","마케팅","영업","IT/개발","연구개발(R&D)"])
    
    
}
