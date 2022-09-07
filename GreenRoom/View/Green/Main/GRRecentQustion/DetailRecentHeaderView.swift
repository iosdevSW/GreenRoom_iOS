//
//  DetailRecentHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/06.
//

import UIKit

final class DetailRecentHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "DetailRecentHeaderView"
    
    //MARK: - Properties
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let headerLabel = UILabel().then {
        $0.numberOfLines = 0
        let attributeString = NSMutableAttributedString(string: "최근 질문", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.sfPro(size: 16, family: .Bold)!
        ])
        
        attributeString.append(NSAttributedString(string: "\n\n방금 올라온 모든 질문리스트를 보여드려요!\n질문에 참여 시 동료들의 모든 답변을 확인할 수 있어요 :)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGray!,
                                                                                                     NSAttributedString.Key.font: UIFont.sfPro(size: 12, family: .Regular)!]))
        $0.attributedText = attributeString
    }
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    private func configureUI(){
        self.backgroundColor = .backgroundGary
        self.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.75)
        }
        
        self.containerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

}
