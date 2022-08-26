//
//  SearchResultNotFountCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/26.
//

import Foundation
import UIKit

final class SearchResultNotFoundCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SearchResultNotFoundCell"
    //MARK: - Properties
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "NotFound")?.withRenderingMode(.alwaysOriginal)
        $0.tintColor = UIColor(red: 34/255.9, green: 76/255.0, blue:  76/255.0, alpha: 1.0)
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(79)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
