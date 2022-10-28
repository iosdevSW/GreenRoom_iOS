//
//  RecentHeader.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/04.
//

import UIKit

protocol RecentHeaderDelegate: AnyObject {
    func didTapViewAllQeustionsButton()
}

final class RecentHeader: BaseCollectionReusableView {
    
    static let reuseIdentifier = "RecentHeader"
    
    //MARK: - Properties
    weak var delegate: RecentHeaderDelegate?
    
    private let headerLabel = UILabel().then {
        $0.text = "최근 질문"
        $0.textColor = .black
        $0.font = .sfPro(size: 20, family: .Bold)
    }
    
    private lazy var viewAllQeustionsButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 12, family: .Regular)
        $0.addAction(UIAction(handler: { _ in
            self.delegate?.didTapViewAllQeustionsButton()
        }), for: .touchUpInside)
        
    }
    
    //MARK: - Configure
    override func configureUI(){
        self.backgroundColor = .white
        self.addSubview(headerLabel)
        self.addSubview(viewAllQeustionsButton)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(22)
        }
        
        viewAllQeustionsButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

}
