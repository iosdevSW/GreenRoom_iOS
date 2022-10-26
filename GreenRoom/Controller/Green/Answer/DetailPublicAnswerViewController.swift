//
//  DetailPublicAnswerViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/10/18.
//

import UIKit
import RxSwift

/// 그린룸 질문에 대한 답변을 클릭했을 때 나오는 전체화면 B13
final class DetailPublicAnswerViewController: BaseViewController {
    
    private let viewModel: DetailPublicAnswerViewModel
    
    private lazy var output = viewModel.transform(input: DetailPublicAnswerViewModel.Input())
    
    private lazy var scrollView = UIScrollView()
    private lazy var headerView = AnswerHeaderView(frame: .zero)
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = self.view.frame.width * 0.1 / 2
        $0.layer.masksToBounds = true
        $0.image = UIImage(named: "GreenRoomIcon")
        $0.backgroundColor = .customGray
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.textColor = .customGray
        $0.text = "박면접"
    }
    
    private lazy var answerLabel = PaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)).then {
        $0.numberOfLines = 0
        $0.textColor = .darkText
        $0.font = .sfPro(size: 16, family: .Regular)
    }
    
    init(viewModel: DetailPublicAnswerViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(handleDismissal))

    }
    
    override func setupAttributes() {
        super.setupAttributes()
    }
    
    override func configureUI() {
        super.configureUI()
        
        let headerHeight = UIScreen.main.bounds.height * 0.3
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(headerHeight)
        }
        
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        self.scrollView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(self.view.frame.width * 0.1)
        }
        
        self.scrollView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        self.scrollView.addSubview(answerLabel)
        answerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
    }
    
    override func setupBinding() {
        super.setupBinding()
        
        output.answer.subscribe(onNext: { [weak self] answer in
            guard let self = self else { return }
            self.answerLabel.text = answer.answer
            self.nameLabel.text = answer.name
            guard let url = URL(string: answer.profileImage) else { return }
            self.profileImageView.kf.setImage(with: url)
        }).disposed(by: disposeBag)
        
        output.header
            .subscribe(onNext: { header in
                self.headerView.question = header
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Selector
    @objc func handleDismissal(){
        self.navigationController?.popViewController(animated: false)
    }
}
