//
//  KeywordRegisterView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class KeywordRegisterView: UIView {

    private var disposeBag = DisposeBag()
    
    var viewModel: RegisterKeywordViewModel
    
    private lazy var input = RegisterKeywordViewModel.Input(
        inputKeyword: self.keywordTextField.rx.text.orEmpty.asObservable(),
        trigger: keywordTextField.rx.controlEvent([.editingDidEndOnExit]).asObservable())
    
    lazy var output = viewModel.transform(input: input)
    
    private var collectionView: UICollectionView!
    
    private lazy var keywordTextField = UITextField().then {
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 10
        $0.placeholder = "키워드를 등록해주세요!"
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textColor = .black
        $0.leftViewMode = .always
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .point
        
        $0.leftView = imageView
    }
    
    private let keywordLabel = UILabel().then {
        $0.text = "키워드"
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textColor = .customGray
    }
    
    init(viewModel: RegisterKeywordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        configureCollectionView()
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Configure
    private func configureUI() {
        self.backgroundColor = .white
        
        let margin = 30
        let textFieldMargin = 25
        
        self.addSubview(keywordTextField)
        keywordTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(textFieldMargin)
            $0.trailing.equalToSuperview().offset(-textFieldMargin)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(40)
        }
        
        self.addSubview(keywordLabel)
        keywordLabel.snp.makeConstraints { make in
            make.top.equalTo(keywordTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(margin)
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(keywordLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 8, left: 30, bottom: 8, right: 2)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .white
        self.collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.reuseIdentifier)
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
    
    private func bind() {
        
        self.output.registeredKeywords.asObservable()
            .bind(to: self.collectionView.rx.items(cellIdentifier: KeywordCell.reuseIdentifier, cellType: KeywordCell.self)) { index, keyword, cell in
                cell.keyword = keyword
            }.disposed(by: disposeBag)
        
        self.keywordTextField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext:{ [weak self] _ in
            self?.keywordTextField.text = nil
        }).disposed(by: disposeBag)
    }
}

//MARK: - CollectionView
extension KeywordRegisterView: UICollectionViewDelegateFlowLayout {
    // 셀 크기설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel().then {
            $0.font = .sfPro(size: 12, family: .Semibold)
            $0.sizeToFit()
        }
        
        output.registeredKeywords
            .subscribe(onNext: { keywords in
                label.text = keywords[indexPath.row]
            }).disposed(by: disposeBag)
        
        return CGSize(width: label.intrinsicContentSize.width + 16, height: 24)
    }
}
