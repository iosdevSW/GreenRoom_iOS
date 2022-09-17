//
//  GreenroomCommonHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/09.
//

import UIKit

final class GreenRoomCommonHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "GreenRoomCommonHeaderView"
    
    var title: String! {
        didSet {
            headerLabel.text = title
        }
    }
    
    //MARK: - Properties
    private let headerLabel = UILabel().then {
        $0.text = "마이 그린룸"
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

