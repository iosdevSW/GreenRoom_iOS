//
//  SectionHeader.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/16.
//

import Foundation
import UIKit

final class SettingHeader: BaseCollectionReusableView {
    
    //MARK: - Properties
    private var headerLabel = UILabel().then {
        $0.font = .sfPro(size: 12, family: .Bold)
        $0.textColor = .customGray
        $0.text = "SettingHeader"
    }
    
    //MARK: - Configure
    func configure(title: String) {
        self.headerLabel.text = title
    }
    
    override func configureUI(){
        backgroundColor = .clear
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(48)
            make.centerY.equalToSuperview()
        }
    }
}
