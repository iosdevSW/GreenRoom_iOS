//
//  KPGreenRoomQuestionsViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/09/11.
//

import UIKit
import RxSwift
import RxCocoa

final class KPGreenRoomQuestionsViewController: BaseViewController {
    //MARK: - Properties
    let viewModel: KPGreenRoomViewModel
    
    private var headerView = InfoHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 220)).then {
        $0.info = Info(title: "참여한 질문", subTitle: "참여한 질문을 모두 보여드려요!\n기간 종료 시 참여한 모든 동료의 답변을 확인할 수 있어요 :)")
        $0.filterShowing = true
    }
    
    private var greenRoomQuestionstableView = UITableView()
    
    private let notFoundImageView = UIImageView().then {
        $0.image = UIImage(named: "NotFound")?.withRenderingMode(.alwaysOriginal)
    }
    
    private let guideLabel = UILabel().then {
        $0.text = "등록된 글이 없어요"
        $0.textColor = UIColor(red: 0.341, green: 0.757, blue: 0.718, alpha: 1).withAlphaComponent(0.2)
        $0.font = .sfPro(size: 12, family: .Bold)
    }
    
    //MARK: - Init
    init(viewModel: KPGreenRoomViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Bind
    override func setupBinding() {
        self.viewModel.greenRoomQuestions
            .bind(to: greenRoomQuestionstableView.rx.items(cellIdentifier: "KPGreenRoomListCell", cellType: KPGreenRoomListCell.self)) { (index,item,cell) in
                cell.configure(question: item)
            }.disposed(by: disposeBag)
        
        self.viewModel.greenRoomQuestions
            .map { $0.count != 0 }
            .bind(onNext: { [weak self] isEmpty in
                self?.notFoundImageView.isHidden = isEmpty
                self?.guideLabel.isHidden = isEmpty
                self?.headerView.filterShowing = isEmpty
            }).disposed(by: disposeBag)
    }
    
    //MARK: - ConfigureUI
    
    override func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.headerView)
        self.headerView.snp.remakeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.height.equalTo(220)
        }
        
        self.greenRoomQuestionstableView = UITableView().then {
            $0.backgroundColor = .backgroundGray

            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalTo(self.headerView.snp.bottom).offset(-28)
            }
        }

        self.greenRoomQuestionstableView.addSubview(self.notFoundImageView)
        self.notFoundImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-80)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(79)
        }

        self.greenRoomQuestionstableView.addSubview(self.guideLabel)
        self.guideLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.notFoundImageView.snp.bottom).offset(20)
        }
    }
}
