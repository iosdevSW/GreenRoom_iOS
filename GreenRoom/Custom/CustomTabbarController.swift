//
//  CustomTabbarController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/30.
//

import UIKit

final class CustomTabbarController: UITabBarController {
    
    var isHidden: Bool = false {
        didSet {
            self.createButton.isHidden = tabBar.isHidden
        }
    }
    
    lazy var createButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.imageView?.tintColor = .white
        $0.layer.cornerRadius = view.frame.width / 14
        $0.addTarget(self, action: #selector(didTapCreateQuestion(_ :)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapUpdateCategories), name: Notification.Name("Category"), object: nil)
        
        initView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func initView() {
        
        self.view.addSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.top.equalTo(tabBar.snp.top).offset(-25)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(view.frame.width / 7)
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
    
    @objc func didTapUpdateCategories() {
        let vc = CategorySelectViewController(viewModel: CategoryViewModel())
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
}
extension CustomTabbarController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
extension CustomTabbarController: CreatePopOverDeleagte {
    func didTapGreenRoomCreate() {
        
        let vc = UINavigationController(rootViewController: CreateGreenRoomViewController())
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func didTapQuestionListCreate() {
        let vc = UINavigationController(rootViewController: CreateQuestionViewController())
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
}
