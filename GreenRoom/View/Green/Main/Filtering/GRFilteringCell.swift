//
//  FilteringCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/05.
//

import UIKit

final class GRFilteringCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GRFilteringCell"
    
    //MARK: - Properties
    private var filteringLabel = UILabel().then {
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
        
        contentView.addSubview(filteringLabel)
        filteringLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-14)
            $0.top.equalToSuperview().offset(11)
            $0.bottom.equalToSuperview().offset(-11)
        }
        
        contentView.backgroundColor = UIColor(red: 248/255.0, green: 254/255.0, blue: 251/255.0, alpha: 1.0)
        contentView.setMainLayer()
    }
    
    func configure(title: String) {
        self.filteringLabel.text = title
    }
}
