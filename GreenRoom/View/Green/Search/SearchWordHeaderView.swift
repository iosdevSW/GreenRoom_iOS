//
//  SearchWordHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/25.
//

import Foundation
import UIKit

final class SearchWordHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "SearchWordHeaderView"
    
    //MARK: - Properties
    private var titleLabel = UILabel().then {
        $0.text = "최근 검색어"
        $0.font = .sfPro(size: 16, family: .Bold)
        $0.textColor = .black
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(34)
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        self.titleLabel.text = title
    }
}
