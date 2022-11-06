//
//  CustomTabbarController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import UIKit

final class MainTabbarController: UITabBarController {
    
    var isHidden: Bool = false {
        didSet { self.createButton.isHidden = tabBar.isHidden }
    }
    
    lazy var createButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.imageView?.tintColor = .white
        $0.layer.cornerRadius = view.frame.width / 12
        $0.addTarget(self, action: #selector(didTapCreateQuestion(_ :)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configureUI() {
        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow()
        
        self.view.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.centerY.equalTo(tabBar.snp.top)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(view.frame.width / 6)
        }
    }
    
    func tabChangedTo(selectedIndex: Int) {
        UIView.animate(withDuration: 0.5) {
            self.createButton.isHidden = selectedIndex == 1
        }
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        UIView.animate(withDuration: 0.5) {
            self.createButton.isHidden = item.tag != 1
        }
    }
    
    //MARK: - Selector
    @objc func didTapUpdateCategories(_ notification: NSNotification) {
        guard let viewModel = notification.userInfo?["viewModel"] as? CategoryViewModel else { return }
        let vc = CategorySelectViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .overFullScreen
        present(vc,animated: false)
    }
                                        
    @objc func didTapCreateQuestion(_ sender: UIButton){
        let popoverVC = CreatePopOverViewController()
        popoverVC.modalPresentationStyle = .popover
        popoverVC.popoverPresentationController?.sourceView = sender
        popoverVC.popoverPresentationController?.delegate = self
        popoverVC.popoverPresentationController?.sourceRect = CGRect(x: 0, y: -115, width: 200, height: 100)
        popoverVC.popoverPresentationController?.permittedArrowDirections = .init(rawValue: 0)
        popoverVC.delegate = self
        self.present(popoverVC, animated: true, completion: nil)
    }
    
    //그룹 편집,추가 화면 전환 액션함수
    @objc func didTapEditGroupButton(_ notification: NSNotification) {
        guard let group = notification.userInfo?["editGroup"] as? GroupModel else { return }
        guard let groupVM = notification.userInfo?["groupVM"] as? GroupViewModel else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "그룹 정보 변경", style: .default) { _ in
            let EditVC = KPGroupEditViewController(groupId: group.id,
                                               categoryId: group.categoryId,
                                               categoryName: group.name)
            let vc = UINavigationController(rootViewController: EditVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        let removeAction = UIAlertAction(title: "그룹 삭제", style: .destructive) { _ in
            KeywordPracticeService().deleteGroup(groupId: group.id){ _ in
                self.showGuideAlert(title: "\(group.name)이 삭제되었습니다.")
                groupVM.updateGroupList()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(editAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        alert.overrideUserInterfaceStyle = .light
        
        present(alert, animated: true)
    }
    
    @objc func didTapAddGroupButton(_ notification: NSNotification) {
        let vc = UINavigationController(rootViewController: KPGroupEditViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func didTapEditQuestionButton(_ notification: NSNotification) {
        guard let id = notification.userInfo?["id"] as? Int else { return }
        let vc = UINavigationController(rootViewController: KPQuestionEditViewController(viewModel: QuestionEditViewModel(id: id, repository: PrivateAnswerRepository())))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    //MARK: - AddObserver
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(didTapUpdateCategories(_:)), name: .categoryObserver, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLoginViewController), name: .authenticationObserver, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTapEditGroupButton(_:)), name: .editGroupObserver, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTapAddGroupButton(_:)), name: .addGroupObserver, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTapEditQuestionButton(_:)), name: .editQuestionObserver, object: nil)
    }
}
extension MainTabbarController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension MainTabbarController: CreatePopOverDeleagte {
    
    func didTapGreenRoomCreate() {
        let viewModel = CreatePublicQuestionViewModel(repositry: ApplyQuestionRepository())
        let vc = UINavigationController(rootViewController: CreateGreenRoomViewController(viewModel: viewModel))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func didTapQuestionListCreate() {
        let viewModel = CreateViewModel(repository: ApplyQuestionRepository())
        let vc = UINavigationController(rootViewController: CreateQuestionViewController(viewModel: viewModel))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
// 로그인 화면 전환 액션 함수
extension MainTabbarController {
    
    @objc func showLoginViewController() {
        let loginVC = LoginViewController(loginViewModel: LoginViewModel())
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: false)
    }
}
