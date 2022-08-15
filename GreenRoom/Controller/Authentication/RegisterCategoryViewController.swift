//
//  RegisterCategoryViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/04.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper

class RegisterCategoryViewController: UIViewController{
    // MARK: - Properties
    var nextButton: UIButton!
    var categoryView: CategoryView!
    
    let disposeBag = DisposeBag()
    
    let name: String
    var categoryId: Int?
    var oauthTokenInfo: OAuthTokenModel!
    let margin = 42
    
    var selectedCategory = "" {
        didSet {
            if selectedCategory == "" {
                nextButton.setEnableButton(false)
            }else {
                nextButton.setEnableButton(true)
            }
        }
    }
    
    //MARK: - ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setNavigationItem()
        configureUI()
        subscribe()
    }
    
    init(name: String, oauthTokenInfo: OAuthTokenModel){
        self.name = name
        self.oauthTokenInfo = oauthTokenInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subscribe(){
        self.categoryView.rx.itemSelected
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                let cell = self.categoryView.cellForItem(at: indexPath) as! CategoryCell
                let title = cell.titleLabel.text!
                cell.frameView.layer.borderColor = UIColor.mainColor.cgColor
                let imageName = title.filter{$0 != "/"}
                cell.imageView.image = UIImage(named: imageName+"S") ?? UIImage()
                self.selectedCategory = title
                self.categoryId = indexPath.row+1
                
            }).disposed(by: disposeBag)
        
        self.categoryView.rx.itemDeselected
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                let cell = self.categoryView.cellForItem(at: indexPath) as! CategoryCell
                let title = cell.titleLabel.text!
                cell.frameView.layer.borderColor = UIColor.customGray.cgColor
                let imageName = title.filter{$0 != "/"}
                cell.imageView.image = UIImage(named: imageName) ?? UIImage()
            }).disposed(by: disposeBag)
    }
}

//MARK: - Configure UI
extension RegisterCategoryViewController {
    func configureUI(){
        let label = UILabel().then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 2
            $0.text = "관심 있는 면접 항목을 골라주세요!"
            $0.textAlignment = .center
            $0.font = .sfPro(size: 30, family: .Semibold)
            $0.textColor = .black
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(114)
                make.width.equalTo(270)
                make.centerX.equalToSuperview()
            }
        }
        
        let layout = UICollectionViewFlowLayout().then{
//            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumLineSpacing = 20
            $0.minimumInteritemSpacing = 20
            let screenWidth = UIScreen.main.bounds.width
            let cellWidth = (screenWidth - CGFloat(margin*2) - (20*3)) / 4
            $0.itemSize = CGSize(width: cellWidth, height: 90)
        }

        
        self.categoryView = CategoryView(frame: .zero, collectionViewLayout: layout).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(CategoryCell.self, forCellWithReuseIdentifier: "categoryCell")
            $0.backgroundColor = .white
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalTo(label.snp.bottom).offset(margin)
                make.leading.equalToSuperview().offset(margin)
                make.trailing.equalToSuperview().offset(-margin)
                make.height.equalTo(340)
            }
            $0.title.bind(to: $0.rx.items(cellIdentifier: "categoryCell", cellType: CategoryCell.self)) {_, title ,cell in
                let imageName = title.filter{$0 != "/"}
                cell.imageView.image = UIImage(named: imageName) ?? UIImage()
                cell.titleLabel.text = title
            }.disposed(by: disposeBag)
        }
        
        self.nextButton = UIButton(type: .system).then{
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitleColor(.white, for: .normal)
            $0.setTitle("다음", for: .normal)
            $0.titleLabel?.font = .sfPro(size: 22, family: .Semibold)
            $0.layer.cornerRadius = 15
            $0.layer.shadowColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.backgroundColor = .mainColor
            $0.setEnableButton(false)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.bottom.equalToSuperview().offset(-96)
                make.leading.equalToSuperview().offset(36)
                make.trailing.equalToSuperview().offset(-36)
                make.height.equalTo(54)
            }
            $0.addTarget(self, action: #selector(didClickNextButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc func didClickNextButton(_: UIButton){
        guard let accessToken = oauthTokenInfo.accessToken else { return }
        guard let oauthType = oauthTokenInfo.oauthType else { return }
        
        LoginService.registUser(accessToken: accessToken, oauthType: oauthType, category: categoryId!, name: name)
        let vc = RegisterCompleteViewControlller()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func setNavigationItem() {
        super.setNavigationItem()
    }
    
}
