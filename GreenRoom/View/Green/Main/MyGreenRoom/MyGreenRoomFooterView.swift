//
//  MyGreenRoomFooterView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/05.
//

import UIKit

final class MyGreenRoomFooterView: BaseCollectionReusableView {
    
    static let reuseIdentifier = "MyGreenRoomFooterView"
    
    private let participantLabel = UILabel().then {
        $0.text = "N명이 참여하고 있습니다."
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 12, family: .Bold)
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override func configureUI() {
        self.backgroundColor = .backgroundGray
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.width.equalTo(70)
            make.height.equalTo(frame.width * 0.08)
        }
        
        self.addSubview(participantLabel)
        participantLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(profileImageView.snp.top).offset(-5)
        }
    }
    
    func configure(with question: MyGreenRoomQuestion) {
        guard question.question != nil else {
            self.participantLabel.text = "그린룸을 개설해주세요!"
            return
        }
        
        self.participantLabel.text = "\(question.participants)명이 참여하고 있습니다."
        guard let images = question.profileImages else { return }
        configureImageStack(urls: images)
    }
    
    private func configureImageStack(urls: [String]) {
        
        DispatchQueue.global().async {
            
            var images: [UIImage] = []
            
            urls.map { URL(string: $0) }
                .forEach { url in
                    guard let url = url,
                          let data = try? Data(contentsOf: url),
                          let image = UIImage(data: data)?.resizeImage(targetSize: CGSize(width: 30, height: 30)),
                          let roundedImage = image.withRoundedCorners() else { return }
                    images.append(roundedImage)
                }
            DispatchQueue.main.async {
                self.profileImageView.setImageStack(images: images)
            }
        }
    }
}
