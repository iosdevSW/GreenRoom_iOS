//
//  TempMyPage.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import UIKit
import Then

protocol ProfileCellDelegate: AnyObject {
    func didTapEditProfileImage()
    func didTapEditProfileInfo()
}

final class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "ProfileCell"
    
    weak var delegate: ProfileCellDelegate?
    
    var profile: ProfileItem? {
        didSet {
            configure()
        }
    }
    
    private var editIconView = UIImageView().then {
        $0.image = UIImage(named:"editButton")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .mainColor
    }
    
    private lazy var profileImageView = UIButton().then {
        $0.tintColor = .customGray
        $0.imageView?.contentMode = .scaleAspectFill
        $0.setImage(UIImage(named: "DefaultProfile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.addTarget(self, action: #selector(didTapEditProfileImageButton), for: .touchUpInside)
        $0.layer.cornerRadius = 45
        
        $0.layer.masksToBounds = true
    }
    
    private var nameLabel = UILabel().then {
        $0.text = "김면접"
        $0.font = .sfPro(size: 16, family: .Bold)
        $0.textAlignment = .center
    }
    
    private var emailLabel = UILabel().then {
        $0.text = "greenroom@gmail.com"
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textAlignment = .center
    }
    
    private lazy var editButton = UIButton().then {
        $0.setTitle("수정하기 ", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        
        $0.titleLabel?.font = .sfProText(size: 12, family: .Regular)
        $0.titleLabel?.textAlignment = .center
        
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.imageView?.tintColor = .customGray
        $0.semanticContentAttribute = .forceRightToLeft
        
        $0.addTarget(self, action: #selector(didTapEditProfileInfo), for: .touchUpInside)
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
    private func configure() {
        guard let profile = profile else {
            return
        }
        nameLabel.attributedText = Utilities.shared.textWithIcon(text: " \(profile.nameText)", image: UIImage(named: "interestIcon"), font: .sfPro(size: 12, family: .Regular), textColor: .black, imageColor: nil, iconPosition: .left)
        emailLabel.text = profile.emailText ?? "1234@naver.com"
        
        guard let image = profile.profileImage else {
            return
        }
        editIconView.isHidden = true
        profileImageView.setImage(image, for: .normal)
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 4
    }
    
    private func configureUI(){
        contentView.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 15
        contentView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(33)
        }
        
        contentView.addSubview(editIconView)
        editIconView.snp.makeConstraints { make in
            make.width.height.equalTo(26)
            make.trailing.equalTo(profileImageView.snp.trailing)
            make.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel,emailLabel,editButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        contentView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.height.equalTo(74)
            make.width.equalTo(172)
        }
    }
    
    
    //MARK: - Selector
    @objc func didTapEditProfileImageButton(){
        delegate?.didTapEditProfileImage()
    }
    
    @objc func didTapEditProfileInfo(){
        delegate?.didTapEditProfileInfo()
    }
}
