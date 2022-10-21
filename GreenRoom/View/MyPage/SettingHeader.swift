//
//  SectionHeader.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/16.
//

import Foundation
import UIKit

final class SettingHeader: UICollectionReusableView {
    
    //MARK: - Properties
    static let reuseIdentifier = "SettingHeader"
    
    private var headerLabel = UILabel().then {
        $0.font = .sfPro(size: 12, family: .Bold)
        $0.textColor = .customGray
        $0.text = "SettingHeader"
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure(title: String) {
        self.headerLabel.text = title
    }
    
    func configureUI(){
        backgroundColor = .clear
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(48)
            make.centerY.equalToSuperview()
        }
    }
}
