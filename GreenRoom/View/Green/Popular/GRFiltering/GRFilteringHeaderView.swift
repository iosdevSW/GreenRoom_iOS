//
//  FilteringHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/05.
//

import UIKit

final class GRFilteringHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "GRFilteringHeaderView"
    
    //MARK: - Properties
    private let filterLabel = UILabel().then {
        $0.numberOfLines = 0
        let attributeString = NSMutableAttributedString(string: "빠르게 필터링", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Bold)!
        ])
        
        attributeString.append(NSAttributedString(string: "\n\n관심사 기반으로 맞춤 키워드를 보여드릴게요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGray!,
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
        self.backgroundColor = .white
        self.addSubview(filterLabel)
        
        filterLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview()
        }
    }
}
