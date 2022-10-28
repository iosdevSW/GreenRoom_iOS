//
//  SetNotificationRow.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/17.
//

import Foundation
import UIKit

final class SetNotificationRow: BaseCollectionViewCell {
    
    static let reuseIdentifier = "SetNotificationRow"
        
    var setting: InfoItem? {
        didSet{ configure() }
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
    
    private lazy var notificationSwitch = UISwitch().then {
        $0.addTarget(self, action: #selector(onClickSwitch(sender:)), for: UIControl.Event.valueChanged)
    }
    
    override func configureUI() {
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
        
        addSubview(notificationSwitch)
        notificationSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-48)
        }
        
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: "isNotificationOn")
    }
    
    //MARK: - Configure
    private func configure() {
        guard let setting = setting else { return }
        iconImageView.image = setting.iconImage
        titleLabel.text = setting.title
    }
    
    //MARK: - selector
    @objc func onClickSwitch(sender: UISwitch){
        UserDefaults.standard.set(sender.isOn, forKey: "isNotificationOn")
        UserDefaults.standard.synchronize()
    }
}
