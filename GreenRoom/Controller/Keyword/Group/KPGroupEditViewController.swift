//
//  KPGroupEditViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit
import RxSwift
import RxCocoa

final class KPGroupEditViewController: BaseViewController {
    //MARK: - Properties
    private let viewModel = CategoryViewModel()
    
    private var categoryCollectionView: UICollectionView!
    
    private lazy var questionTextView = UITextView().then {
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.text = "그룹 이름을 입력해주세요:)"
        $0.textColor = .customGray
        $0.backgroundColor = .white
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        $0.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner]
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.borderWidth = 2
    }
    
    private let completeButton = UIButton(type: .system).then{
        $0.backgroundColor = .mainColor
        $0.setTitle("작성완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Semibold)
        
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor.customGray.cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    //MARK: - Init
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.hideKeyboardWhenTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Bind
    override func setupBinding() {
        self.viewModel.categories
            .bind(to: self.categoryCollectionView.rx.items(cellIdentifier: "categoryCell", cellType: CategoryCell.self)) {index, title ,cell in
                let id = index + 1
                guard let category = CategoryID(rawValue: id) else { return }
                
                cell.imageView.image = category.nonSelectedImage
                cell.frameView.layer.borderColor = UIColor.customGray.cgColor
                cell.titleLabel.text = category.title
                
            }.disposed(by: disposeBag)
        
        categoryCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.categoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                let index = indexPath.row+1
                
                guard let category = CategoryID(rawValue: index) else { return }
                cell.frameView.layer.borderColor = UIColor.mainColor.cgColor
                cell.imageView.image = category.SelectedImage
                self?.viewModel.selectedCategoryObservable.accept(category.rawValue)
                
            }).disposed(by: disposeBag)
        
        categoryCollectionView.rx.itemDeselected
            .bind(onNext: { [weak self] indexPath in
                let cell = self?.categoryCollectionView.cellForItem(at: indexPath) as! CategoryCell
                let index = indexPath.row + 1
                
                guard let category = CategoryID(rawValue: index) else { return }
                cell.frameView.layer.borderColor = UIColor.customGray.cgColor
                cell.imageView.image = category.nonSelectedImage
                
            }).disposed(by: disposeBag)
        
     
        PublishSubject<[String:String]>
            .combineLatest(self.viewModel.selectedCategoryObservable, questionTextView.rx.text,
                           resultSelector: {[
                            "id" : String($0),
                            "text" : $1!
                           ]
            })
            .bind(onNext: { [weak self]dic in
                if dic["text"] == "" || dic["text"] == "그룹 이름을 입력해주세요:)" || dic["id"] == "-1" {
                    self?.completeButton.isHidden = true
                }else {
                    self?.completeButton.isHidden = false
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        let imageView = UIImageView(image: .init(named: "folder")).then {
            $0.tintColor = .customGray
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(32)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
                make.width.equalTo(14)
                make.height.equalTo(12)
            }
        }
        
        let subLabel = UILabel().then {
            $0.text = "그룹을 만들어 질문을 관리하세요."
            $0.textColor = .customGray
            $0.font = .sfPro(size: 12, family: .Regular)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalTo(imageView.snp.trailing).offset(6)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            }
        }
        
        let guideLabel = UILabel().then {
            $0.numberOfLines = 2
            $0.font = .sfPro(size: 30, family: .Regular)
            $0.textColor = .black
            $0.text = "그룹 내용을\n작성해주세요"
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(32)
                make.top.equalTo(subLabel.snp.bottom).offset(4)
            }
        }
        
        let nameLabel = UILabel().then {
            $0.text = "이름입력"
            $0.font = .sfPro(size: 12, family: .Regular)
            $0.textColor = .customGray
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(32)
                make.top.equalTo(guideLabel.snp.bottom).offset(38)
            }
        }
        
        self.view.addSubview(self.questionTextView)
        self.questionTextView.snp.makeConstraints{ make in
            make.top.equalTo(nameLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview().offset(-36)
            make.height.equalTo(100)
        }
        
        let categorySelectionLabel = UILabel().then {
            $0.text = "직무선택"
            $0.font = .sfPro(size: 12, family: .Regular)
            $0.textColor = .customGray
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(32)
                make.top.equalTo(questionTextView.snp.bottom).offset(38)
            }
        }
        
        let margin = 42
        let layout = UICollectionViewFlowLayout().then{
            $0.minimumLineSpacing = 6
            $0.minimumInteritemSpacing = 20
            let screenWidth = UIScreen.main.bounds.width
            let cellWidth = (screenWidth - CGFloat(margin*2) - (20*3)) / 4
            $0.itemSize = CGSize(width: cellWidth, height: 90)
        }
        
        self.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
            $0.backgroundColor = .white
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(categorySelectionLabel.snp.bottom).offset(9)
                make.leading.equalToSuperview().offset(margin)
                make.trailing.equalToSuperview().offset(-margin)
                make.height.equalTo(318)
            }
        }
        
        self.view.addSubview(self.completeButton)
        self.completeButton.snp.makeConstraints{ make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-6)
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(54)
        }
        
    }
}
