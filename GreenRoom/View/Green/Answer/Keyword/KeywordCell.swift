//
//  RegisterKeywordCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/23.
//

import UIKit

final class KeywordCell: UICollectionViewCell {
    
    var keyword: String! {
        didSet { self.keywordLabel.text = keyword }
    }
    
    //MARK: - Properties
    private var keywordLabel = UILabel().then {
        $0.textColor = .customDarkGray
        $0.text = "keyword"
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.backgroundColor = .white
        $0.textAlignment = .center
    }
    
    //MARK: - Lifecylce
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
//        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = bounds.height / 2
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.customGray.cgColor
        
        self.contentView.addSubview(keywordLabel)
        
        self.keywordLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        print(self.bounds.size)
    }
}
