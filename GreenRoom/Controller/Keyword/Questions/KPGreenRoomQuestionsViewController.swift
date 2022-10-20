//
//  KPGreenRoomQuestionsViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/11.
//

import UIKit

final class KPGreenRoomQuestionsViewController: BaseViewController {
    //MARK: - Properties
    private var headerView = InfoHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 220)).then {
        $0.info = Info(title: "참여한 질문", subTitle: "참여한 질문을 모두 보여드려요!\n기간 종료 시 참여한 모든 동료의 답변을 확인할 수 있어요 :)")
        $0.filterShowing = true
    }
    
    private var tableView: UITableView!
    
    private let notFoundImageView = UIImageView().then {
        $0.image = UIImage(named: "NotFound")?.withRenderingMode(.alwaysOriginal)
    }
    
    private let guideLabel = UILabel().then {
        $0.text = "등록된 글이 없어요"
        $0.textColor = UIColor(red: 0.341, green: 0.757, blue: 0.718, alpha: 1).withAlphaComponent(0.2)
        $0.font = .sfPro(size: 12, family: .Bold)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func configureUI() {
        
        self.view.backgroundColor = .white
        self.view.addSubview(headerView)
        headerView.snp.remakeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        self.tableView = UITableView().then {
            $0.backgroundColor = .backgroundGray

            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(self.headerView.snp.bottom)
            }
        }

        self.tableView.addSubview(self.notFoundImageView)
        self.notFoundImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(79)
        }

        self.tableView.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.notFoundImageView.snp.bottom).offset(20)
        }
    }
}
