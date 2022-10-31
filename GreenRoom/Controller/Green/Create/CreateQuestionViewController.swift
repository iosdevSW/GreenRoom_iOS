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
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    private let viewModel: CreateViewModel
    
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
        $0.backgroundColor = .white
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
    }
    
    private let selectedLabel = UILabel().then {
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
    
    //MARK: - LifeCycle
    init(viewModel: CreateViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .mainColor
        
    }
    
    //MARK: - configure
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
        self.view.addSubview(selectedLabel)
        self.view.addSubview(collectionView)
        self.view.addSubview(doneButton)
        
        self.subtitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(18)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(6)
        }
        
        self.questionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(titleLabel.snp.bottom).offset(39)
        }
        
        self.questionTextView.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(100)
        }
        
        self.selectedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(34)
            make.top.equalTo(questionTextView.snp.bottom).offset(39)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(42)
            make.trailing.equalToSuperview().offset(-42)
            make.top.equalTo(selectedLabel.snp.bottom).offset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.bottom.equalToSuperview().offset(-35)
            make.height.equalTo(63)
        }
    }
    
    
    override func setupAttributes() {
        super.setupAttributes()
        
        configureCollectionView()
    }
    
    //MARK: - Binding
    override func setupBinding() {
        
        let input = CreateViewModel.Input(
            question: questionTextView.rx.text.orEmpty.asObservable(),
            category: collectionView.rx.itemSelected.map { $0.row + 1}.asObservable(),
            returnTrigger: questionTextView.rx.didEndEditing.asObservable(),
            submit: doneButton.rx.tap.asObservable())
        
        self.questionTextView.rx.didBeginEditing
            .withUnretained(self)
            .bind { onwer, _ in
                if onwer.questionTextView.text == "면접자 분들은 나에게 어떤 질문을 줄까요?"{
                    onwer.questionTextView.text = ""
                    onwer.questionTextView.textColor = .black
                }
                
            }.disposed(by: disposeBag)
        
        self.questionTextView.rx.didEndEditing
            .withUnretained(self)
            .bind { onwer, _ in
                if onwer.questionTextView.text == nil || onwer.questionTextView.text == "" {
                    onwer.questionTextView.text = "면접자 분들은 나에게 어떤 질문을 줄까요?"
                    onwer.questionTextView.textColor = .customGray
                }
            }.disposed(by: disposeBag)
        
        self.viewModel.categories
            .bind(to: self.collectionView.rx.items(
                cellIdentifier: String(describing: CategoryCell.self),
                cellType: CategoryCell.self)
            ) { index, title, cell in
                guard let category = Category(rawValue: index + 1) else { return }
                cell.category = category
            }.disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        output.isValid
            .bind(to: self.doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.isValid
            .map { $0 ? 1.0 : 0.5}
            .bind(to: doneButton.rx.alpha)
            .disposed(by: disposeBag)
        
        output.successMessage
            .withUnretained(self)
            .emit(onNext: { onwer, message in
                
                let alert = onwer.comfirmAlert(title: "작성 완료", subtitle: message) { _ in
                    onwer.dismiss(animated: true)
                }
                onwer.present(alert, animated: true)
            }).disposed(by: disposeBag)
        
        output.failMessage
            .withUnretained(self)
            .emit(onNext: { onwer, message in
                let alert = onwer.comfirmAlert(title: "작성 실패", subtitle: message) { _ in
                    print("다시 작성")
                }
                onwer.present(alert, animated: true)
            }).disposed(by: disposeBag)
    }
    
    @objc func dismissal(){
        self.dismiss(animated: false)
    }
}

//MARK: - Configure
extension CreateQuestionViewController {
    
    private func configureCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - CGFloat(42 * 2) - (20 * 3)) / 4
        layout.itemSize = CGSize(width: cellWidth, height: 90)
        
        return layout
    }
    
    private func configureCollectionView() {
        self.collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: String(describing: CategoryCell.self))
        self.collectionView.backgroundColor = .white
    }
}
