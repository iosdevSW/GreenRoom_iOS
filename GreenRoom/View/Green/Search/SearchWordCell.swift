//
//  SearchWordCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import UIKit

final class SearchWordCell: BaseCollectionViewCell {
    
    static let reuseIdentifier = "SearchWordCell"
    
    //MARK: - Properties
    var tagType: SearchTagItem! {
        didSet {
            self.tagLabel.text = tagType.text
            self.contentView.backgroundColor = tagType.type.backgroundColor
            self.contentView.layer.borderColor = tagType.type.borderColor.cgColor
        }
    }
    
    private let tagLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    override func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .customGray
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-14)
            $0.top.equalToSuperview().offset(11)
            $0.bottom.equalToSuperview().offset(-11)
        }
        
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 15
    }

}
