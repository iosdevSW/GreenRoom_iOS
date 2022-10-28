//
//  MyGreenRoomHeader.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/05.
//
import UIKit

final class MyGreenRoomHeader: BaseCollectionReusableView {
    
    static let reuseIdentifier = "MyGreenRoomHeader"
    
    //MARK: - Properties
    private let headerLabel = UILabel().then {
        $0.text = "마이 그린룸"
        $0.textColor = .black
        $0.font = .sfPro(size: 20, family: .Bold)
    }
    
    //MARK: - Configure
    override func configureUI(){
        self.backgroundColor = .backgroundGray
        self.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(22)
        }
    }
}
