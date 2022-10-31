//
//  RecentHeader.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/04.
//

import UIKit

protocol RecentHeaderDelegate: AnyObject {
    func didTapViewAllQeustionsButton(type: GreenRoomSectionModel?)
}

final class GreenRoomSectionHeader: BaseCollectionReusableView {
    
    static let reuseIdentifier = "GreenRoomSectionHeader"
    
    var type: GreenRoomSectionModel? {
        didSet { configure() }
    }
    
    //MARK: - Properties
    weak var delegate: RecentHeaderDelegate?
    
    private let titleLabel = UILabel().then {
        $0.text = "최근 질문"
        $0.textColor = .black
        $0.font = .sfPro(size: 20, family: .Bold)
    }
    
    private lazy var viewAllQeustionsButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 12, family: .Regular)
    }
    
    //MARK: - Configure
    override func configureUI(){
        self.backgroundColor = .white
        self.addSubview(titleLabel)
        self.addSubview(viewAllQeustionsButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(22)
        }
        
        viewAllQeustionsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    override func bind() {
        viewAllQeustionsButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { onwer, _ in
                onwer.delegate?.didTapViewAllQeustionsButton(type: onwer.type)
            }).disposed(by: disposeBag)
    }
    
    private func configure() {
        guard let type else { return }
        self.titleLabel.text = type.title
        
        switch type {
        case .recent, .MyQuestionList:
            self.viewAllQeustionsButton.isHidden = false
        default:
            self.viewAllQeustionsButton.isHidden = true
        }
    }

}
