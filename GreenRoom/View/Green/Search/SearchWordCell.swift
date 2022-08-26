//
//  SearchWordCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/24.
//

import UIKit

final class SearchWordCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SearchWordCell"
    
    //MARK: - Properties
    var tagType: SearchTagItem? {
        didSet {
            guard let tagType = tagType else {
                return
            }
            self.tagLabel.text = tagType.text
            self.contentView.backgroundColor = tagType.type.backgroundColor
            self.contentView.layer.borderColor = tagType.type.borderColor.cgColor
        }
    }
    
    private var tagLabel = UILabel().then {
        
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
        $0.sizeToFit()
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
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
