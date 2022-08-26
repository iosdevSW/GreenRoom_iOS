//
//  FAQViewController.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/19.
//

import Foundation
import UIKit
import RxSwift

final class FAQViewController: BaseViewController {
    
    private var viewModel: MyPageViewModel!
    private var searchBar = UISearchBar()
    private var tableView: UITableView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .mainColor
    }
    
    //MARK: - Lifecycle
    init(viewModel: MyPageViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI(){

        self.view.backgroundColor = .white
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(41)
            make.trailing.equalToSuperview().offset(-41)
        }
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupAttributes() {
        self.configureSearchBar()
        self.configureTableView()
    }
    
    override func setupBinding() {
        searchBar.rx.text.orEmpty
        //0.5초 기다림
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)   .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                if let searchFAQ = self?.viewModel.presetFAQ.filter({ $0.question.hasPrefix(query) })  {
                    self?.viewModel.shownFAQ.onNext(searchFAQ)
                }
            }).disposed(by: disposeBag)
        
        viewModel.shownFAQ.bind(to: tableView.rx.items(cellIdentifier: FAQCell.reuseIdentifier, cellType: FAQCell.self)) { (index: Int, element: FAQ, cell: FAQCell) in
            cell.data = element
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? FAQCell else { return }
            self?.tableView.beginUpdates()
            cell.isShowing.toggle()
            self?.tableView.endUpdates()
            
        }).disposed(by: disposeBag)
    }
}

//MARK: - SetAttribute
extension FAQViewController {
    private func configureSearchBar(){
        searchBar.backgroundColor = .white
        searchBar.setImage(UIImage(systemName: "megaphone"), for: .search, state: .normal)
        searchBar.setImage(UIImage(systemName: "xmark"), for: .clear, state: .normal)
        searchBar.placeholder = "궁금한 건 무엇이든 물어보세요!"
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 5
        
        searchBar.searchTextField.leftView?.tintColor = .mainColor
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = UIColor.white
            
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainColor!])
            
            textfield.textColor = UIColor.mainColor
            textfield.layer.borderColor = UIColor.customGray.cgColor
            textfield.layer.borderWidth = 0.7
            textfield.layer.cornerRadius = 10
            textfield.tintColor = .mainColor
            textfield.font = .sfPro(size: 12, family: .Regular)
        }
    }
    
    private func configureTableView(){
        
        tableView = UITableView()
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsMultipleSelection = true
        tableView.register(FAQCell.self, forCellReuseIdentifier: FAQCell.reuseIdentifier)
    }
}
//MARK: - UITableViewDelegate
extension FAQViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) as? FAQCell else { return 52 }
        return CGFloat(cell.isShowing ? 68 + cell.data.height : 52)
    }
}


