//
//  ProfileImageView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/11/23.
//

import UIKit
import RxSwift
import Kingfisher

final class ProfileImageView: UIImageView {
    
    // MARK: - UI
    
    // MARK: - Properties
    
    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.backgroundColor = .customDarkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = self.frame.height / 2
        self.layer.cornerRadius = cornerRadius
    }
    
    func setImage(at profileImageURL: String) {
        self.kf.setImage(with: URL(string: profileImageURL), placeholder: UIImage(named:"CharacterProfile1"))
    }
}

extension Reactive where Base: ProfileImageView {
    var setImage: Binder<String> {
        return Binder(self.base) { imageView, url in
            imageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named:"CharacterProfile1"))
        }
    }
}
