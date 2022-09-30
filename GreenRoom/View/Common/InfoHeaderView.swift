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
        didSet { configure() }
    }
    
    var filterShowing: Bool = false {
        didSet {
            if filterShowing { configureFilterLayout() }
//            if isUseKP {
//                self.filterView.filterButton.isHidden = filterHidden
//                self.filterView.selectedCategoriesCollectionView.isHidden = filterHidden
//            } else {
//                filterView.remove FromSuperview()
//            }
        }
    }
    
    /** 키워드 연습에서 쓰일 경우에 레이아웃 재정의 해주기 위한 프로퍼티 */
    var isUseKP: Bool = false {
        didSet { configureUseKP() }
    }
    
    private var filterView = FilterView()
    private var titleLabel = Utilities.shared.generateLabel(text: "Title", color: .black, font: .sfPro(size: 16, family: .Semibold))
    private var subTitleLabel = Utilities.shared.generateLabel(text: "SubTitleLabel", color: .customGray, font: .sfPro(size: 12, family: .Regular))
   
    

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
 
        addLineSpacing(8)
        
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
        self.subTitleLabel.text = info.subTitle
    }
    
    private func addLineSpacing(_ spacing: CGFloat) {
        guard let text = subTitleLabel.text else { return }
         let attributeString = NSMutableAttributedString(string: text)

         let style = NSMutableParagraphStyle()

         style.lineSpacing = spacing
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
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(bounds.height * 0.33)
        }
    }
    
    private func configureUseKP() {
        titleLabel.snp.remakeConstraints{ make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(42)
        }
        
        subTitleLabel.snp.remakeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        filterView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
    }
}
