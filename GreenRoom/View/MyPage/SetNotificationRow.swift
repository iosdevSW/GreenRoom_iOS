//
//  SetNotificationRow.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/17.
//

import Foundation
import UIKit

final class SetNotificationRow: UICollectionViewCell {
    
    static let reuseIdentifier = "SetNotificationRow"
        
    var setting: InfoItem? {
        didSet{
            configure()
        }
    }
    
    private var iconImageView = UIImageView().then {
        $0.tintColor = .customGray
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "mail")
    }
    
    private var titleLabel = UILabel().then {
        $0.font = .sfPro(size: 18, family: .Regular)
        $0.textColor = .black
        $0.text = "알림 설정"
    }
    
    private var notificationSwitch = UISwitch().then {
       
        $0.addTarget(self, action: #selector(onClickSwitch(sender:)), for: UIControl.Event.valueChanged)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(iconImageView)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(27)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(notificationSwitch)
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: "isNotificationOn")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configure() {
        guard let setting = setting else { return }
        iconImageView.image = setting.iconImage
        titleLabel.text = setting.title
    }
    //MARK: - selector
    @objc func onClickSwitch(sender: UISwitch){
        let isNotificationOn = sender.isOn
        UserDefaults.standard.set(isNotificationOn, forKey: "isNotificationOn")
        print(UserDefaults.standard.bool(forKey: "isNotificationOn"))
//        UserDefaults.standard.synchronize()
    }
}
