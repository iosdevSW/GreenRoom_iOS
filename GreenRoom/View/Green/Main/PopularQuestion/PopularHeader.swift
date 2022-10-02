//
//  PopularHeader.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import UIKit

final class PopularHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "PopularHeader"
    
    //MARK: - Properties
    private let headerLabel = UILabel().then {
        $0.text = "인기질문"
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
        self.backgroundColor = .backgroundGray
        self.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(22)
        }
    }
}
