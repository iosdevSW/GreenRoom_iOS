//
//  GreenroomCommonHeaderView.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/09/09.
//

import UIKit
import RxSwift

protocol GreenRoomCommonHeaderViewDelegate: AnyObject {
    func didTapViewAllMyQeustions()
}

final class GreenRoomCommonHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "GreenRoomCommonHeaderView"
    
    //MARK: - Properties
    weak var delegate: GreenRoomCommonHeaderViewDelegate?
    var disposeBag = DisposeBag()
    
    private let headerLabel = UILabel().then {
        $0.text = "나의 질문 리스트"
        $0.textColor = .black
        $0.font = .sfPro(size: 20, family: .Bold)
    }
    
    private lazy var viewAllQeustionsButton = UIButton().then {
        $0.setTitle("전체보기", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.font = .sfPro(size: 12, family: .Regular)
    }
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configure(title: String) {
        headerLabel.text = title
    }
    
    private func configureUI(){
        self.backgroundColor = .backgroundGray
        self.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(22)
        }
    }
    
    private func binding() {
        viewAllQeustionsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.didTapViewAllMyQeustions()
            }).disposed(by: disposeBag)
    }
}

