//
//  InfoHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/06.
//

import UIKit

final class InfoHeaderView: BaseCollectionReusableView {
    
    //MARK: - Properties
    var info: Info! {
        didSet { configure() }
    }
    
    var filterShowing: Bool = false {
        didSet { filterShowing ? configureFilterLayout() : filterView.removeFromSuperview() }
    }
    
    var filterView = FilterView(viewModel: CategoryViewModel())
    private var titleLabel = Utilities.shared.generateLabel(text: "Title", color: .black, font: .sfPro(size: 16, family: .Semibold))
    private var subTitleLabel = Utilities.shared.generateLabel(text: "SubTitleLabel", color: .customGray, font: .sfPro(size: 12, family: .Regular))
    
    //MARK: - Init
    override func configureUI(){
        self.backgroundColor = .white
        addSubview(titleLabel)
        addSubview(subTitleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(bounds.size.height * 0.1)
            $0.leading.equalToSuperview().offset(bounds.size.width * 0.08)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
    
    private func configure() {
        self.titleLabel.text = info.title
        
        let attributeString = NSMutableAttributedString(string: info.subTitle)
        
        let style = NSMutableParagraphStyle()
        
        style.lineSpacing = 10
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        subTitleLabel.attributedText = attributeString
    }

    private func configureFilterLayout() {
        addSubview(filterView)
        filterView.backgroundColor = .backgroundGray
        filterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
}
