//
//  KPGroupsViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/03.
//

import UIKit

final class KPGroupsViewController: BaseViewController {
    //MARK: - Properties
    private let viewModel: BaseQuestionsViewModel
    
    let groupView = GroupView().then {
//        $0.groupCountingLabel.text = "총 N개의 그룹"
        $0.backgroundColor = .white
    }
    
    //MARK: - Init
    init(viewModel: BaseQuestionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        self.view.addSubview(self.groupView)
        self.groupView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
