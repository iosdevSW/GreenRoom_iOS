//
//  CateogryCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/06.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    //MARK: - Properties
    let frameView = UIView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.customGray.cgColor
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner)
    }
    let imageView = UIImageView().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    let titleLabel = UILabel().then{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textColor = .customDarkGray
    }
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.frameView)
        frameView.snp.makeConstraints{ make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(frameView.snp.width)
        }
        
        frameView.addSubview(imageView)
        imageView.snp.makeConstraints{ make in
            make.centerY.centerX.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(frameView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
