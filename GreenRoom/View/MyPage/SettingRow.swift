//
//  SectionRow.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/16.
//

import Foundation
import UIKit

final class SettingRow: UICollectionViewCell {
    
    static let reuseIdentifier = "SettingRow"
    
    var setting: InfoItem? {
        didSet{
            DispatchQueue.main.async {
                self.configureSettingOption(setting: self.setting)
            }
        }
    }
    
    private var iconImageView = UIImageView().then {
        $0.tintColor = .customGray
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "mail")?.withRenderingMode(.alwaysOriginal)
    }
    
    private var titleLabel = UILabel().then {
        $0.font = .sfPro(size: 18, family: .Regular)
        $0.textColor = .black
        $0.text = "알림 설정"
    }
    
    private var infoLabel = UILabel().then {
        $0.textAlignment = .right
        $0.text = "1.01.01"
        $0.font = .sfProText(size: 17, family: .Regular)
        $0.textColor = .customGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(58)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(27)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSettingOption(setting: InfoItem?){
        
        guard let setting = setting else { return }
        iconImageView.image = setting.iconImage
        
        titleLabel.text = setting.title
        
        switch setting.setting {
        case .language:
            self.infoLabel.attributedText = Utilities.shared.textWithIcon(text: "한국어", image: UIImage(systemName: "globe"),imageColor: .mainColor,iconPosition: .right)
        case .interest:
            let cateogryId = UserDefaults.standard.object(forKey: "CategoryID") as? Int ?? 1
            let category = Category(rawValue: cateogryId) ?? .common
            
            self.infoLabel.attributedText = Utilities.shared.textWithIcon(text: category.title, image: UIImage(named: category.selectedImageName), imageColor: nil, iconPosition: .right)
        case .version:
            return
        default:
            self.infoLabel.isHidden = true
        }
    }
}
