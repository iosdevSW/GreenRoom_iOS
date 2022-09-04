//
//  PracticeFinishViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/28.
//

import UIKit
import AVKit

class KPFinishViewController: BaseViewController, AVPlayerViewControllerDelegate{
    //MARK: - Properties
    let viewmodel: KeywordViewModel
    let urls: [URL]?
    
    let goalFrameView = UIView().then {
        $0.backgroundColor = .customGray.withAlphaComponent(0.05)
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    let goalProgressBarView = ProgressBarView().then{
        $0.guideLabel.text = "목표까지 5% 남았어요"
        $0.removeGesture()
    }
    
    let resultTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(PracticeResultCell.self, forCellReuseIdentifier: "PracticeResultCell")
    }
    
    var avPlayer = AVPlayer()
    var avView = UIView()
    
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
        if let per = self.viewmodel.goalPersent {
            let newX =  self.goalProgressBarView.progressBar.frame.width * per + 10
            UIView.animate(withDuration: 0.5){
                self.goalProgressBarView.goalView.frame.origin = CGPoint(x: newX, y: 0)
            }
        }
    }
    
    @objc func didClickReviewButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(KPReviewViewController(viewmodel: viewmodel), animated: true)
    }
    
    //MARK: - Bind
    override func setupBinding() {
        viewmodel.selectedQuestionObservable
            .bind(to: resultTableView.rx.items(cellIdentifier: "PracticeResultCell", cellType: PracticeResultCell.self)) { index, title, cell in
                cell.questionLabel.text = "Q\(index+1)\n\(title)"
                cell.keywordPersent.text = "75%"
                cell.keywordsLabel.text = "아무거나 일단넣기"
                cell.categoryLabel.text = "공통"
                
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        resultTableView.rx.itemSelected
            .bind(onNext: { indexPath in
                self.navigationController?.pushViewController(KPDetailViewController(viewmodel: self.viewmodel), animated: true)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - CofigureUI
    override func configureUI() {
        self.view.addSubview(self.goalFrameView)
        self.goalFrameView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(276)
        }
        
        let goalTitleLabel = UILabel().then{
            $0.text = "전체 키워드 매칭률"
            $0.textColor = .black
            $0.font = .sfPro(size: 16, family: .Semibold)
            
            self.goalFrameView.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.top.equalToSuperview().offset(107)
                make.leading.equalToSuperview().offset(44)
            }
        }
        
        _ = UIButton().then { // 비디오 버튼
            $0.tintColor = .mainColor
            $0.setImage(UIImage(named: "camera"), for: .normal)
            $0.addTarget(self, action: #selector(didClickReviewButton(_:)), for: .touchUpInside)
            self.view.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.leading.equalTo(goalTitleLabel.snp.trailing).offset(8)
                make.centerY.equalTo(goalTitleLabel.snp.centerY)
                make.width.height.equalTo(20)
            }
        }
        
        self.goalFrameView.addSubview(self.goalProgressBarView)
        self.goalProgressBarView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints{ make in
            make.top.equalTo(goalFrameView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
