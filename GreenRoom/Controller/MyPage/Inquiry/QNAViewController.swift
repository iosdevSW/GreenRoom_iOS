//
//  QNAViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/19.
//

import Foundation
import UIKit

final class QNAViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: MyPageViewModel
    private var collectionView: UICollectionView!
    
    private let placeholder = "궁금한 내용을 입력해주세요!"
    
    private let imageTitle = UILabel().then {
        $0.text = "이미지 첨부"
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textColor = .customGray
    }
    
    private let askTitle = UILabel().then {
        $0.text = "문의 내용"
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textColor = .customGray
    }
    
    private lazy var askTextView = UITextView().then {
        
        $0.backgroundColor = UIColor.init(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        $0.layer.cornerRadius = 15
        $0.text = self.placeholder
        $0.delegate = self
    }
    
    //MARK: - Lifecycle
    
    init(viewModel: MyPageViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .mainColor
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(handleDoneButton))
        navigationController?.navigationItem.rightBarButtonItem = doneButton
    }
    
    //MARK: - configure
    private func configureUI(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(imageTitle)
        imageTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(42)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(imageTitle.snp.leading)
            make.top.equalTo(imageTitle.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
            make.height.equalTo(133)
        }
        
        self.view.addSubview(askTitle)
        askTitle.snp.makeConstraints { make in
            make.leading.equalTo(imageTitle)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
        }
        
        self.view.addSubview(askTextView)
        askTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(askTitle.snp.bottom).offset(14)
            make.width.equalTo(368)
            make.height.equalTo(325)
        }
    }
    
    private func configureCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 107, height: 107)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 11
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
    }
    
    //MARK: - Selector
    @objc func handleDoneButton(){
        
    }
}

extension QNAViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}
