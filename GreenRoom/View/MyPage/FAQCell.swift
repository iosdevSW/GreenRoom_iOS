//
//  FAQCell.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/19.
//

import Foundation
import UIKit

class FAQCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "FAQCell"
    
    var data: FAQ! {
        didSet { configure() }
    }

    var isShowing: Bool = false {
        didSet{
            self.answerLabel.isHidden = !self.isShowing
        }
    }
    
    private var questionLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textAlignment = .left
        $0.text = "Q. "
    }
    
    private lazy var answerLabel = PaddingLabel(padding: UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)).then {
        $0.textColor = .black
        $0.clipsToBounds = true
        $0.font = .sfPro(size: 16, family: .Bold)
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .customGray
        $0.isHidden = true
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
    
    private func configureUI(){
        contentView.addSubview(questionLabel)
        questionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(42)
            make.top.equalToSuperview().offset(14)
        }
        
        contentView.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(62)
            make.trailing.equalToSuperview().offset(-40)
            
        }
    }
    
    private func configure(){
        guard let data = data else { return }
        
        let attributedString = NSMutableAttributedString(string: data.answer)

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points

        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        // *** Set Attributed String to your label ***
        
        questionLabel.text = "Q. \(data.question)"
        answerLabel.attributedText = attributedString
    }

    
}
