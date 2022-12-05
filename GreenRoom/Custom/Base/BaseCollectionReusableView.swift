//
//  BaseCollectionReusableView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/28.
//

import UIKit
import RxSwift

class BaseCollectionReusableView: UICollectionReusableView {
    
    var disposeBag = DisposeBag()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        
    }
    
    func configureUI() {
        
    }
}
