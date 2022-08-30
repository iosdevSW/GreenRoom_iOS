//
//  CreateQuestionViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/29.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateQuestionViewController: BaseViewController {
    
    //MARK: - Properteis
    
    private var collectionView: UICollectionView!
    private let viewModel = CreateViewModel()
    
    private let subtitleLabel = UILabel().then {
        $0.attributedText = Utilities.shared.textWithIcon(text: " 나만 볼 수 있는 질문입니다.", image: UIImage(named:"createQuestionList"), font: .sfPro(size: 12, family: .Regular), textColor: .gray, imageColor: .customGray, iconPosition: .left)
    }
    
    private let titleLabel = Utilities.shared.generateLabel(text: "나만의 질문을\n만들어주세요.", color: .black, font: .sfPro(size: 30, family: .Regular))
    
    private let questionLabel = UILabel().then {
        $0.text = "질문 입력"
        $0.textColor = .customGray
        $0.font = .sfPro(size: 12, family: .Regular)
    }
    
    private lazy var questionTextView = UITextView().then {
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.text = "면접자 분들은 나에게 어떤 질문을 줄까요?"
        $0.textColor = .customGray
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
    }
    
    private let seletedLabel = UILabel().then {
        $0.text = "직무선택"
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textColor = .customGray
    }
    
    private lazy var doneButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.setTitle("작성완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .mainColor
        
    }
    override func configureUI() {
        self.view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissal))
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(titleLabel)
        self.view.addSubview(questionLabel)
        self.view.addSubview(questionTextView)
        self.view.addSubview(seletedLabel)
        self.view.addSubview(collectionView)
        self.view.addSubview(doneButton)
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
        }
        
        questionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(titleLabel.snp.bottom).offset(39)
        }
        
        questionTextView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(100)
        }
        
        seletedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(questionTextView.snp.bottom).offset(39)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(42)
            make.trailing.equalToSuperview().offset(-42)
            make.top.equalTo(seletedLabel.snp.bottom).offset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-35)
            make.height.equalTo(63)
        }
    }
    
    override func setupAttributes() {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - CGFloat(42 * 2) - (20 * 3)) / 4
        layout.itemSize = CGSize(width: cellWidth, height: 90)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
        collectionView.backgroundColor = .white
        
    }
    
    
    override func setupBinding() {
        questionTextView.rx.didBeginEditing
            .bind { [weak self] _ in
                if self?.questionTextView.text == "면접자 분들은 나에게 어떤 질문을 줄까요?"{
                    self?.questionTextView.text = ""
                    self?.questionTextView.textColor = .black
                }
                
            }.disposed(by: disposeBag)
        
        questionTextView.rx.didEndEditing
            .bind { [weak self] _ in
                if self?.questionTextView.text == nil || self?.questionTextView.text == "" {
                    self?.questionTextView.text = "면접자 분들은 나에게 어떤 질문을 줄까요?"
                    self?.questionTextView.textColor = .customGray        //다시 placeholder 글자색으로(연한색)
                }
            }.disposed(by: disposeBag)
        
        questionTextView.rx.text
            .orEmpty
            .bind(to: viewModel.questionObserver)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.collectionView.cellForItem(at: indexPath) as! CategoryCell
                let index = indexPath.row+1
                
                guard let category = CategoryID(rawValue: index) else { return }
                cell.frameView.layer.borderColor = UIColor.mainColor.cgColor
                cell.imageView.image = category.SelectedImage
                
                self?.viewModel.selectedCategoryObserver.onNext(index)
            }).disposed(by: disposeBag)
        
        collectionView.rx.itemDeselected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.collectionView.cellForItem(at: indexPath) as! CategoryCell
                let index = indexPath.row + 1
                
                guard let category = CategoryID(rawValue: index) else { return }
                cell.frameView.layer.borderColor = UIColor.customGray.cgColor
                cell.imageView.image = category.nonSelectedImage
                
                self?.viewModel.selectedCategoryObserver.onNext(index)
            }).disposed(by: disposeBag)
        
        
        viewModel.categories.bind(to: self.collectionView.rx.items(cellIdentifier: "categoryCell", cellType: CategoryCell.self)) { index, title, cell in
            guard let category = CategoryID(rawValue: index + 1) else { return }
            cell.imageView.image = category.nonSelectedImage
            cell.titleLabel.text = category.title
        }.disposed(by: disposeBag)
        
        viewModel.isValid
            .bind(to: self.doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isValid
            .map { $0 ? 1.0 : 0.3}
            .bind(to: doneButton.rx.alpha)
            .disposed(by: disposeBag)
        
    }
    
    @objc func dismissal(){
        self.dismiss(animated: false)
    }
}

