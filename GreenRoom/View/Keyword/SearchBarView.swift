//
//  SearchBarView.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit

class SearchBarView: UIView {
    //MARK: - Properties
//    let searchTextField = UITextField().then{
//        $0.attributedPlaceholder = NSAttributedString(string: "키워드로 검색해보세요!",
//                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.customGray!])
//    }
//    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.mainColor.cgColor
        self.layer.borderWidth = 2
    }
    
    
    //MARK: - ConfigureUI
    func configureUI(){
        let magnifierImageView = UIImageView().then{
            $0.image = UIImage(named: "magnifier") ?? UIImage()
        }
        self.addSubview(magnifierImageView)
        magnifierImageView.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(16)
        }
        
        
//        self.addSubview(self.searchTextField)
//        self.searchTextField.snp.makeConstraints{ make in
//            make.leading.equalTo(magnifierImageView.snp.trailing).offset(6)
//            make.top.bottom.equalToSuperview()
//        }
    }
}
