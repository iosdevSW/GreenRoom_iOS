//
//  KPQuestionEditViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/10/10.
//

import UIKit
import RxSwift

final class KPQuestionEditViewController: BaseViewController {
    
    //MARK: - Properties
    private var mode: PrivateAnswerMode = .unWritten {
        didSet {
            var barButtonItems = [UIBarButtonItem]()
            switch self.mode {
            case .edit:
                self.setEditMode()
                barButtonItems.append(.init(customView: doneButton))
            case .written(let answer):
                self.setWrittenMode(answer: answer)
                barButtonItems.append(.init(customView: doneButton))
                barButtonItems.append(.init(customView: deleteButton))
            case .unWritten:
                self.setUnwrittenMode()
                barButtonItems.append(.init(customView: deleteButton))
            }
            
            self.navigationItem.rightBarButtonItems = barButtonItems
        }
    }
    
    private var viewModel: QuestionEditViewModel!
    
    private var headerView = AnswerHeaderView(frame: .zero)
    private var keywordView: KeywordRegisterView!
    private var collectionView: UICollectionView!
    
    private lazy var defaultView = UIImageView().then {
        $0.image = UIImage(named: "NotFound")?.withRenderingMode(.alwaysOriginal)
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
        $0.layer.masksToBounds = false
    }
    
    private var defaultLabel = UILabel().then {
        $0.text = "등록된 글이 없어요"
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textColor = .init(red: 87/255.0, green: 193/255.0, blue: 193/255.0, alpha: 1.0)
    }
    
    private var answerPostButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.setTitle("답변 작성하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 20, family: .Bold)
        $0.layer.cornerRadius = 8
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.imageView?.tintColor = .white
    }
    
    private let doneButton = UIButton().then {
        $0.setTitle("확인",for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var answerTextView = UITextView().then {
        $0.isEditable = true
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.sizeToFit()
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.mainColor.cgColor
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 2
        $0.isScrollEnabled = true
        $0.attributedText = viewModel.placeholder.addLineSpacing(foregroundColor: .lightGray)
    }
    
    //MARK: - Lifecycle
    init(viewModel: QuestionEditViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        self.keywordView = KeywordRegisterView(viewModel: RegisterKeywordViewModel(
            id: viewModel.id,
            answerType: .kpQuestion,
            repository: DefaultRegisterKeywordRepository())
        )
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
        
        guard let tabbarcontroller = tabBarController as? MainTabbarController else { return }
        tabbarcontroller.createButton.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let tabbarcontroller = tabBarController as? MainTabbarController else { return }
        tabbarcontroller.createButton.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Configure
    override func configureUI() {
        super.configureUI()
        
        let headerHeight = UIScreen.main.bounds.height * 0.3
        
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        self.view.addSubview(defaultView)
        defaultView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        self.view.addSubview(defaultLabel)
        defaultLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(defaultView.snp.bottom).offset(20)
        }
        
        self.view.addSubview(answerPostButton)
        answerPostButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: self.mode == .edit ? doneButton : deleteButton
        )
    }
    
    override func setupBinding() {
        answerTextView.rx.didBeginEditing
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                if self.answerTextView.text == self.viewModel.placeholder {
                    self.answerTextView.text = nil
                    self.answerTextView.textColor = .black
                }
            }).disposed(by: disposeBag)
        
        answerTextView.rx.didEndEditing
            .subscribe(onNext: { [weak self] _ in
                
                guard let self = self else { return }
                
                if self.answerTextView.text.isEmpty || self.answerTextView.text == nil {
                    self.answerTextView.attributedText = self.viewModel.placeholder.addLineSpacing(foregroundColor: .lightGray)
                }
                
            }).disposed(by: disposeBag)

        let input = QuestionEditViewModel.Input(text: answerTextView.rx.text.orEmpty.asObservable(),
                                                 endEditingTrigger: self.answerTextView.rx.didEndEditing.asObservable(),
                                                 keywords: keywordView.output.registeredKeywords.asObservable(),
                                                 deleteButtonTrigger: deleteButton.rx.tap.flatMap { self.showAlert(title: "질문 삭제", message: "질문을 삭제하시겠습니까?\n한 번 삭제 후 되돌릴 수 없습니다.")},
                                                 doneButtonTrigger: self.doneButton.rx.tap.asObservable())
        
        doneButton.rx.tap.subscribe(onNext: {
            self.answerTextView.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        let output = viewModel.transform(input: input)
        
        answerPostButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.mode = .edit
            }).disposed(by: disposeBag)
        
        output.answer.subscribe(onNext: { [weak self] answer in
            
            guard let self = self else { return }
            self.headerView.question = QuestionHeader(id: answer.id, question: answer.question, categoryName: answer.categoryName, groupCategoryName: "")
            
            if answer.answer == "" || answer.answer == nil {
                self.mode = .unWritten
            } else {
                self.mode = .written(answer: answer.answer ?? "")
            }

        }).disposed(by: disposeBag)
        
        output.successMessage.emit(onNext: { [weak self] message in
            guard let self = self else { return }
            let alert = self.comfirmAlert(title: "등록 완료", subtitle: message) { _ in
                NotificationCenter.default.post(name: .updateGroupQuestionObserver, object: nil)
                self.dismiss(animated: true)
            }
            self.present(alert, animated: true)
        }).disposed(by: disposeBag)
        
        output.failMessage.emit(onNext: { [weak self] message in
            guard let self = self else { return }
            let alert = self.comfirmAlert(title: "등록 실패", subtitle: message) { _ in
                
            }
            self.present(alert, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func configureTextViewLayout() {
        self.view.addSubview(keywordView)
        keywordView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(15)
            make.height.equalTo(115)
        }
        
        self.view.addSubview(answerTextView)
        answerTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.top.equalTo(keywordView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Selector
    @objc func handleDismissal(){
        self.dismiss(animated: false)
    }
}

//MARK: - SetMode
extension KPQuestionEditViewController {
    private func setWrittenMode(answer: String) {
        self.defaultView.isHidden = true
        self.defaultLabel.isHidden = true
        self.answerPostButton.isHidden = true
        
        self.answerTextView.attributedText = answer.addLineSpacing(foregroundColor: .black)
        configureTextViewLayout()
    }
    
    private func setUnwrittenMode() {
        self.defaultView.isHidden = false
        self.defaultLabel.isHidden = false
        self.answerPostButton.isHidden = false
    }
    
    private func setEditMode() {
        self.defaultView.isHidden = true
        self.defaultLabel.isHidden = true
        self.answerPostButton.isHidden = true
        
        configureTextViewLayout()
    }
}
