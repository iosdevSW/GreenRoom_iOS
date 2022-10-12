//
//  PracticeFinishViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/28.
//

import UIKit
import RxSwift
import AVKit

class KPFinishViewController: BaseViewController{
    //MARK: - Properties
    let viewmodel: KeywordViewModel
    let urls: [URL]?
    
    let goalFrameView = UIView().then {
        $0.backgroundColor = .customGray.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    private lazy var goalProgressBarView = ProgressBarView().then{
        $0.titleLabel.text = "전체 키워드 매칭률"
        $0.guideLabel.text = "목표까지 5% 남았어요"
        $0.removeGesture()
        
        $0.buttonImage = self.viewmodel.recordingType
    }
    
    let resultTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(PracticeResultCell.self, forCellReuseIdentifier: "PracticeResultCell")
    }
    
    //MARK: - Init
    init(viewmodel: KeywordViewModel) {
        self.viewmodel = viewmodel
        self.urls = self.viewmodel.videoURLs
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let per = self.viewmodel.goalPersent.value
        let newX =  self.goalProgressBarView.progressBar.frame.width * per
        
        UIView.animate(withDuration: 0.5){
            self.goalProgressBarView.goalView.center.x = newX
            
        }
    }
    
    //MARK: - Selector
    @objc func didClickReviewButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(KPReviewViewController(viewModel: viewmodel), animated: true)
    }
    
    //MARK: - Bind
    override func setupBinding() {
        viewmodel.selectedQuestions
            .bind(to: resultTableView.rx.items(cellIdentifier: "PracticeResultCell", cellType: PracticeResultCell.self)) { index, item, cell in
                
                let persent = item.persent ?? 0
                cell.questionLabel.text = "Q\(index+1)\n\(item.question)"
                cell.keywordPersent.text = String(format: "%2.f%%", persent * 100)
                cell.keywordsLabel.text = item.keyword.joined(separator: "  ")
                cell.categoryLabel.text = item.categoryName
                
            }.disposed(by: disposeBag)
        
        resultTableView.rx.itemSelected
            .bind(onNext: { indexPath in
                let vc = KPDetailViewController(viewmodel: self.viewmodel)
                vc.indexPath = indexPath
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        viewmodel.totalPersent
            .bind(onNext: { per in
                print(per)
                self.goalProgressBarView.progressBar.progress = per
            }).disposed(by: disposeBag)
    }
    
    
    //MARK: - CofigureUI
    override func configureUI() {
        self.view.addSubview(self.goalFrameView)
        self.goalFrameView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(276)
        }
            
        self.goalFrameView.addSubview(self.goalProgressBarView)
        self.goalProgressBarView.reviewButton.addTarget(self, action: #selector(didClickReviewButton(_:)), for: .touchUpInside)
        self.goalProgressBarView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.goalFrameView.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
        self.view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints{ make in
            make.top.equalTo(goalFrameView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        _ = UILabel().then {
            $0.text = "질문별 매칭률"
            $0.textColor = .customGray
            $0.font = .sfPro(size: 12, family: .Semibold)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(44)
                make.top.equalTo(self.goalFrameView.snp.bottom).offset(14)
            }
        }
    }
    
    func setNavigationBarColor(_ color: UIColor) {
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()    // 불투명하게
            appearance.backgroundColor = color
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance    // 동일하게 만들기
        }else {
            self.navigationController?.navigationBar.barTintColor = color
        }
    }
}
