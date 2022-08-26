//
//  PrepareKeywordPracticeViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/24.
//

import UIKit

class PrepareKeywordPracticeViewController: UIViewController{
    //MARK: - Properties
    let viewmodel: KeywordViewModel
    
    var collectionView: UICollectionView!

    //MARK: - Init
    init(viewmodel: KeywordViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - ConfigureUI
    func configureUI(){
//        let layout = UICollectionViewCompositionalLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then{
            $0.backgroundColor = .white
        }
    }
}

extension PrepareKeywordPracticeViewController {
    
}
