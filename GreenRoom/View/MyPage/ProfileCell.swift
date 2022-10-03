//
//  TempMyPage.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import Foundation
import UIKit
import Then
import Kingfisher

protocol ProfileCellDelegate: AnyObject {
    func didTapEditProfileImage()
    func didTapEditProfileInfo()
}

final class ProfileCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "ProfileCell"
    
    weak var delegate: ProfileCellDelegate?
    
    var user: User? {
        didSet {
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    private var editIconView = UIImageView().then {
        $0.image = UIImage(named:"editButton")
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.tintColor = .mainColor
    }
    
    private lazy var profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90)).then {
        $0.tintColor = .customGray
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 45
        $0.backgroundColor = .clear
        $0.layer.masksToBounds = true
    }
    
    private var nameLabel = UILabel().then {
        $0.text = "김면접"
        $0.font = .sfPro(size: 16, family: .Bold)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var editButton = UIButton().then {
        $0.setTitle("수정하기 ", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        
        $0.titleLabel?.font = .sfProText(size: 12, family: .Regular)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.textColor = .black
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
        guard let user = user, let category = Category(rawValue: user.categoryID) else {
            return
        }
        
        nameLabel.attributedText = Utilities.shared.textWithIcon(text: " \(user.name)", image: UIImage(named: category.selectedImageName), font: .sfPro(size: 12, family: .Regular), textColor: .black, imageColor: nil, iconPosition: .left)
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 4
        
        guard let url = URL(string: user.profileImage) else { return }
        
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,placeholder: UIImage(named:"DefaultProfile"))
    }
    
    private func configureUI(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapEditProfileImageButton(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
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
        
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel,editButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(8)
            make.height.equalTo(60)
            make.width.equalTo(172)
        }
    }
    
    
    //MARK: - Selector
    @objc func didTapEditProfileImageButton(tapGestureRecognizer: UITapGestureRecognizer){
        delegate?.didTapEditProfileImage()
    }
    
    @objc func didTapEditProfileInfo(){
        delegate?.didTapEditProfileInfo()
    }
}
