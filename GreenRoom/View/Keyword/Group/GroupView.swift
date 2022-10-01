//
//  GroupView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/02.
//

import UIKit

final class GroupView: UIView {
    //MARK: - Properties
    var groupStatus: GroupStatus = .zero {
        didSet {
            if groupStatus == .zero {
                groupCountingLabel.text = "그룹을 추가해주세요 :)"
                notFoundImageView.isHidden = false
                guideLabel.isHidden = false
            } else {
                groupCountingLabel.text = "총 N개의 그룹"
                notFoundImageView.isHidden = true
                guideLabel.isHidden = true
            }
        }
    }
    
    lazy var groupTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
    }
    
    private let groupCountingLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .customDarkGray
    }
    
    let addGroupButton = UIButton(type: .system).then {
        let title = "그룹추가"
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .zero
            var titleAttr = AttributedString.init(title)
            titleAttr.font = .sfPro(size: 16, family: .Bold)
            titleAttr.foregroundColor = UIColor.point
            config.attributedTitle = titleAttr
            $0.configuration = config
        }else {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(.point, for: .normal)
            $0.titleLabel?.font = .sfPro(size: 16, family: .Bold)
            $0.contentEdgeInsets = .zero
        }
    }
    
    private let notFoundImageView = UIImageView().then {
        $0.image = UIImage(named: "NotFound")?.withRenderingMode(.alwaysOriginal)
    }
    
    private let guideLabel = UILabel().then {
        $0.text = "등록된 글이 없어요"
        $0.textColor = UIColor(red: 0.341, green: 0.757, blue: 0.718, alpha: 1).withAlphaComponent(0.2)
        $0.font = .sfPro(size: 12, family: .Bold)
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .customGray.withAlphaComponent(0.1)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ConfigureUI
    private func configureUI() {
        self.addSubview(self.groupCountingLabel)
        self.groupCountingLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(39)
            make.top.equalToSuperview().offset(37)
        }
        
        self.addSubview(self.addGroupButton)
        self.addGroupButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-39)
            make.top.equalToSuperview().offset(37)
        }
        
        self.addSubview(self.notFoundImageView)
        self.notFoundImageView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(79)
        }
        
        self.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.notFoundImageView.snp.bottom).offset(20)
        }
        
        self.addSubview(self.groupTableView)
        self.groupTableView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(38)
            make.trailing.equalToSuperview().offset(-38)
            make.top.equalTo(groupCountingLabel.snp.bottom).offset(22)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
