//
//  FooterPageView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/04.
//

import UIKit
import RxCocoa
import RxSwift

final class RecentPageFooterView: BaseCollectionReusableView {
    
    private let bannerPageControl = UIPageControl().then{
        $0.pageIndicatorTintColor = .customGray
        $0.currentPageIndicatorTintColor = .mainColor
        $0.currentPage = 0
        $0.numberOfPages = 3
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = .backgroundGray
    }
    
    func bind(input: PublishSubject<Int>, pageNumber: Int) {
        self.bannerPageControl.numberOfPages = pageNumber
        
        input.subscribe(onNext: { [weak self] currentPage in
            self?.bannerPageControl.currentPage = currentPage
        }).disposed(by: disposeBag)
    }
    
    override func configureUI() {
        self.addSubview(bannerPageControl)
        self.bannerPageControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
