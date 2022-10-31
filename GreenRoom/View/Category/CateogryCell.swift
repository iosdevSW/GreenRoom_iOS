//
//  CateogryCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/06.
//

import UIKit

final class CategoryCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    var category: Category! {
        didSet { configure() }
    }
    
    override var isSelected: Bool {
        didSet {
            self.frameView.layer.borderColor = self.isSelected ? UIColor.mainColor.cgColor : UIColor.customGray.cgColor
            
            let imageName = self.isSelected ? category.selectedImageName : category.defaultImageName
            self.imageView.image = UIImage(named: imageName)
        }
    }
    
    private let frameView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.customGray.cgColor
        $0.layer.cornerRadius = 15
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner)
    }
    
    private let imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textColor = .customDarkGray
    }
    
    //MARK: - Init
    func configure() {
        self.imageView.image = UIImage(named: category.defaultImageName)
        self.titleLabel.text = category.title
    }
    
    override func configureUI() {
        self.layer.borderColor = UIColor.customGray.cgColor
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
}
