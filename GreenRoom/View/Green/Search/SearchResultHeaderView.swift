//
//  SearchResultHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/26.
//

import Foundation
import UIKit

final class SearchResultHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "SearchResultHeaderView"
    
    //MARK: - Properties
    private var titleLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Bold)
        $0.text = "검색결과없음"
        $0.textColor = .black
    }
    
    private var subtitleLabel = UILabel().then {
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.numberOfLines = 0
        $0.text = """
                관련된 모든 질문리스트를 보여드려요!
                질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)
                """
        $0.textColor = .customGray
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        backgroundColor = .white
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(47)
        }
        
        self.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(7)
            $0.leading.equalToSuperview().offset(46)
        }
    }
}
