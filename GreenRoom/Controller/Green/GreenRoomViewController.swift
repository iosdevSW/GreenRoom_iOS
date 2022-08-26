//
//  GreenRoomViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import RxSwift
import SwiftKeychainWrapper

class GreenRoomViewController: BaseViewController {
    
    //MARK: - Properties
    let viewModel = GreenRoomViewModel()
    
    private var collectionView: UICollectionView!
    
    private lazy var greenRoomButton = UIButton().then {
        $0.setTitle("그린룸", for: .normal)
        $0.setTitleColor(.mainColor, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(filterGreenRoom), for: .touchUpInside)
        $0.tag = 0
    }
     
    private lazy var questionListButton = UIButton().then {
        $0.setTitle("질문리스트", for: .normal)
        $0.setTitleColor(.customGray, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(filterGreenRoom), for: .touchUpInside)
        $0.tag = 1
    }
    
    private let filterLabel = UILabel().then {
        $0.numberOfLines = 0
        let attributeString = NSMutableAttributedString(string: "빠르게 필터링\n", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.sfPro(size: 20, family: .Bold)!
        ])
        
        attributeString.append(NSAttributedString(string: "\n관심사 기반으로 맞춤 키워드를 보여드릴게요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGray!,
                                                                                                     NSAttributedString.Key.font: UIFont.sfPro(size: 12, family: .Regular)!]))
        $0.attributedText = attributeString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func setupBinding() {
        viewModel.isLogin()
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { isToken in
                if isToken {
                    print("자동로그인")
                }else {
                    print("로그인필요")
                    let loginVC = LoginViewController(loginViewModel: LoginViewModel())
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: false)
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        iconView.image = UIImage(named: "GreenRoomIcon")?.withRenderingMode(.alwaysOriginal)
        iconView.contentMode = .scaleAspectFit
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: iconView)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "bookmark"),
                style: .plain,
                target: self,
                action: #selector(didTapScrap)),
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .plain,
                target: self,
                action: #selector(didTapSearch))
        ]
        
        navigationController?.navigationBar.tintColor = .mainColor
        
    }
    
    override func configureUI(){
        
        self.view.backgroundColor = .white
        
        let buttonStack = UIStackView(arrangedSubviews: [greenRoomButton,questionListButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing
        self.view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(27)
            make.leading.equalToSuperview().offset(view.frame.width / 5)
            make.trailing.equalToSuperview().offset(-view.frame.width / 5)
            make.height.equalTo(30)
        }
        
        let line = UIView()
        line.backgroundColor = .mainColor
        line.setGradient(
            color1: UIColor(red: 110/255.0, green: 234/255.0, blue: 174/255.0, alpha: 1.0),
            color2: UIColor(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1.0))
        
        self.view.addSubview(line)
        line.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(view.frame.width/15)
            make.trailing.equalToSuperview().offset(-view.frame.width/15)
            make.height.equalTo(3)
        }
        
        self.view.addSubview(filterLabel)
        filterLabel.snp.makeConstraints { make in
            make.top.equalTo(line.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(33)
        }
        
    }
    
    override func setupAttributes() {
        self.configureNavigationBar()
    }
    
    @objc func filterGreenRoom(_ sender: UIButton){
        let questionColor: UIColor = sender.tag == 0 ? .customGray : .mainColor
        let greenRoomColor: UIColor = sender.tag == 0 ? .mainColor : .customGray
        
        self.questionListButton.setTitleColor(questionColor, for: .normal)
        self.greenRoomButton.setTitleColor(greenRoomColor, for: .normal)
    }
    
    @objc func didTapSearch(){
        let vc = GRSearchViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapScrap(){
        print("DEBUG Did tap scrap")
    }
}

//MARK: - collectionView
extension GreenRoomViewController {
    func configureCollecitonView(){
        let layout = self.generateLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.backgroundColor = .backgroundGary
        collectionView.register(PopularQuestionCell.self, forCellWithReuseIdentifier: PopularQuestionCell.reuseIdentifer)
        collectionView.register(PopularHeader.self, forSupplementaryViewOfKind: PopularHeader.reuseIdentifier, withReuseIdentifier: PopularHeader.reuseIdentifier)
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            
            return nil
        }
    }
    
    func generatePopularQuestionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.4))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }

    func generateRecentQuestionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(155),
            heightDimension: .absolute(172))
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "AlbumsViewController.sectionHeaderElementKind",
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
        
        
        //    func generateMyGRLayout() -> NSCollectionLayoutSection {
        //        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        //
        //        let item = NSCollectionLayoutItem(layoutSize: <#T##NSCollectionLayoutSize#>)
        //    }
    }

}

