//
//  RecentHeader.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/04.
//

import UIKit

final class RecentHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "RecentHeader"
    
    //MARK: - Properties
    private let headerLabel = UILabel().then {
        $0.text = "최근 질문"
        $0.textColor = .black
        $0.font = .sfPro(size: 20, family: .Bold)
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configureUI(){
        self.backgroundColor = .white
        self.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(22)
        }
    }
}
