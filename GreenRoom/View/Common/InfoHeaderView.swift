//
//  InfoHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/06.
//

import UIKit

final class InfoHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "InfoHeaderView"
    
    //MARK: - Properties
    var info: Info! {
        didSet {
            self.titleLabel.text = info.title
            self.subTitleLabel.text = info.subTitle
        }
    }
    
    private var titleLabel = Utilities.shared.generateLabel(text: "Title", color: .black, font: .sfPro(size: 16, family: .Regular))
    
    private var subTitleLabel = Utilities.shared.generateLabel(text: "SubTitleLabel", color: .customGray, font: .sfPro(size: 12, family: .Regular))
   
    private var filter = FilterView(viewModel: CategoryViewModel())

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(filter)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(bounds.size.height * 0.1)
            $0.leading.equalToSuperview().offset(bounds.size.width * 0.08)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        filter.backgroundColor = .backgroundGary
        filter.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(bounds.height * 0.33)
        }
        
    }
    
}
