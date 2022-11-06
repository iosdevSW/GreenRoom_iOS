//
//  FilterItemsCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/21.
//

import UIKit

final class FilterItemsCell: UICollectionViewCell {
    
    //MARK: - Properties
    var category: Category? {
        didSet { configure() }
    }
    
    private let itemLabel = UILabel().then{
        $0.textColor = . customGray
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.sizeToFit()
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .white
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(itemLabel)
        self.itemLabel.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func configure() {
        
        guard let category = category else { return }
        let attributedString = NSMutableAttributedString.init(string: category.title)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: category.title.count))
        itemLabel.attributedText = attributedString
    }

}
