//
//  GroupView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/02.
//

import UIKit
import RxSwift
import RxCocoa

final class GroupView: UIView {
    //MARK: - Properties
    let viewModel: GroupViewModel
    let disposeBag = DisposeBag()
    
    lazy var groupTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
    }
    
    private let groupCountingLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.textColor = .customDarkGray
    }
    
    private let addGroupButton = UIButton(type: .system).then {
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
    init(viewModel: GroupViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.bind()
        self.backgroundColor = .customGray.withAlphaComponent(0.1)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setColorHilightAttribute(text: String, hilightString: String, color: UIColor) -> NSMutableAttributedString {
        let attributedStr = NSMutableAttributedString(string: text)
        attributedStr.addAttribute(.foregroundColor, value: color, range: (text as NSString).range(of: hilightString))
        
        return attributedStr
    }
    
    //MARK: - Selector
    @objc func didClickEditButton(_ sender: UIButton) {
        guard let group = viewModel.groupsObservable.value.filter({ $0.id == sender.tag}).first else { return }
    
        NotificationCenter.default.post(name: .editGroupObserver, object: nil, userInfo: ["groupEdit" : group ] )
    }
    
    //MARK: Bind
    private func bind() {
        viewModel.groupsObservable
            .bind(to: self.groupTableView.rx.items(cellIdentifier: "GroupCell", cellType: GroupCell.self)) { index, item, cell in
                cell.groupNameLabel.text = item.name
                cell.categoryLabel.text = CategoryID(rawValue: item.categoryId)?.title
                cell.questionCountingLabel.attributedText = self.setColorHilightAttribute(text: "질문 \(item.questionCnt)개",
                                                                                     hilightString: "\(item.questionCnt)",
                                                                                     color: .point)
                cell.selectionStyle = .none
                cell.editButton.tag = item.id
                
                cell.editButton.addTarget(self, action: #selector(self.didClickEditButton(_:)), for: .touchUpInside)
            }.disposed(by: disposeBag)
        
        viewModel.groupCounting
            .bind(onNext: { [weak self] count in
                if count == 0 {
                    self?.groupCountingLabel.text = "그룹을 추가해주세요 :)"
                    self?.notFoundImageView.isHidden = false
                    self?.guideLabel.isHidden = false
                } else {
                    self?.notFoundImageView.isHidden = true
                    self?.guideLabel.isHidden = true
                    self?.groupCountingLabel.attributedText = self?.setColorHilightAttribute(text: "총 \(count)개의 그룹",
                                                                                       hilightString: "\(count)개",
                                                                                       color: .point)
                }
            }).disposed(by: disposeBag)
    
        self.addGroupButton.rx.tap
            .bind(onNext: {
                NotificationCenter.default.post(name: .AddGroupObserver, object: nil)
            }).disposed(by: disposeBag)
        
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
