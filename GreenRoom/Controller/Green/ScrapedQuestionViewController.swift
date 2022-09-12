//
//  ScrapedQuestionViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/11.
//

import UIKit

final class ScrapedQuestionViewController: BaseViewController {

    //MARK: - Properties
    private var collectionView: UICollectionView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapEditButton))
    }
    override func setupAttributes() {
        self.configureCollectionView()
    }
    
    override func setupBinding() {
        
    }
    
    @objc func didTapEditButton() {
        
    }
}

//MARK: - CollectionView
extension ScrapedQuestionViewController {
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.width * 0.43
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 25, left: 25, bottom: 0, right: 25)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InfoHeaderView.self, forSupplementaryViewOfKind: InfoHeaderView.reuseIdentifier, withReuseIdentifier: InfoHeaderView.reuseIdentifier)
        collectionView.register(ScrapViewCell.self, forCellWithReuseIdentifier: ScrapViewCell.reuseIdentifier)
    }
}
