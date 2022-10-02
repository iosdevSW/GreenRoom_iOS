//
//  MyGreenRoomFooterView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/05.
//

import UIKit

final class MyGreenRoomFooterView: UICollectionReusableView {
    
    static let reuseIdentifier = "MyGreenRoomFooterView"
    
    private let participantLabel = UILabel().then {
        $0.text = "N명이 참여하고 있습니다."
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 12, family: .Bold)
    }
    
    private lazy var profileImageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = bounds.width * 0.08 / 2
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "GreenRoomIcon")
        $0.tintColor = .mainColor
        $0.layer.masksToBounds = false
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        self.backgroundColor = .backgroundGray
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.width.height.equalTo(bounds.width * 0.08)
        }
        
        self.addSubview(participantLabel)
        participantLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(profileImageView.snp.top).offset(-5)
        }
    }
}
