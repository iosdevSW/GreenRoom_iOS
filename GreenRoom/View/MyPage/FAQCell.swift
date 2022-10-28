//
//  FAQCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/19.
//

import Foundation
import UIKit

final class FAQCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "FAQCell"
    
    var data: FAQ! {
        didSet { configure() }
    }
    
    lazy var expanded: Bool = data.expanded {
        didSet {
            self.data.updateExpanded()
        }
    }
    
    private var questionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textAlignment = .left
        $0.text = "Q. "
    }
    
    private lazy var answerLabel = PaddingLabel(padding: UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)).then {

        $0.clipsToBounds = true
        $0.layer.maskedCorners = [.layerMaxXMinYCorner,
                                  .layerMaxXMaxYCorner,
                                  .layerMinXMaxYCorner]
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .customGray
        $0.numberOfLines = 0
    }
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print(self.data.expanded)
        self.answerLabel.isHidden = self.data.expanded
    }
    
    private func configureUI(){
        self.backgroundColor = .white
        contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(42)
            make.top.equalToSuperview().offset(14)
        }
        
        
    }
    
    private func configure(){
        guard let data = data else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        questionLabel.text = "Q. \(data.question)"
        answerLabel.attributedText = NSAttributedString(string: data.answer,
                                                        attributes: [
                                                            NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                                            NSAttributedString.Key.font: UIFont.sfPro(size: 16, family: .Bold),
                                                            NSAttributedString.Key.foregroundColor: UIColor.black])
        self.answerLabel.isHidden = !self.data.expanded

        if self.data.expanded {
            contentView.addSubview(answerLabel)
            answerLabel.snp.makeConstraints { make in
                make.top.equalTo(questionLabel.snp.bottom).offset(8)
                make.leading.equalToSuperview().offset(62)
                make.trailing.equalToSuperview().offset(-40)
            }
        } else {
            answerLabel.removeFromSuperview()
        }
    }
    
    private func didTapExpanded() {
        
    }
    private func setset() {
        
                
        
    }
    
}
