//
//  FilterItemsCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/21.
//

import UIKit

class FilterItemsCell: UICollectionViewCell {
    //MARK: - Properties
    let itemLabel = UILabel().then{
        $0.textColor = . customGray
        $0.font = .sfPro(size: 12, family: .Regular)
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        self.addSubview(itemLabel)
        self.itemLabel.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
}
