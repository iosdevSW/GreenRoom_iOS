//
//  MyPageViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/01.
//

import UIKit
import SwiftKeychainWrapper
import RxSwift
import RxDataSources

final class MyPageViewController: UIViewController {
    
    private var viewModel: MyPageViewModel!
    private var disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = MyPageViewModel()
        configureCollectionView()
        configureUI()
        bind()
    }
    
    private func configureUI(){
        self.view.addSubview(self.collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureCollectionView() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        self.collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseIdentifier)
        collectionView.register(SettingHeader.self, forSupplementaryViewOfKind: SettingHeader.reuseIdentifier, withReuseIdentifier: SettingHeader.reuseIdentifier)
        collectionView.register(SettingRow.self, forCellWithReuseIdentifier: SettingRow.reuseIdentifier)
        collectionView.register(SetNotificationRow.self, forCellWithReuseIdentifier: SetNotificationRow.reuseIdentifier)
        collectionView.isScrollEnabled = false
        
    }
    
    private func bind() {
        let dataSource = dataSource()
        viewModel.MyPageDataSource.bind(to: collectionView.rx.items(dataSource: dataSource))
                   .disposed(by: disposeBag)
    }
}

//MARK: - CollectionViewDataSoruce
extension MyPageViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<MyPageSectionModel> {
            return RxCollectionViewSectionedReloadDataSource<MyPageSectionModel> {
                dataSource, collectionView, indexPath, item in
                print("DEBUG: \(item)")
                switch item {
    
                case .profile(profileInfo: let profile) :
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as? ProfileCell else {
                        return UICollectionViewCell()
                    }
                    cell.profile = profile
                    cell.delegate = self
                    return cell
                case .setting(settingInfo: let setting) :
                    switch setting.setting {
                    case .notification:
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SetNotificationRow.reuseIdentifier, for: indexPath) as? SetNotificationRow else { return UICollectionViewCell() }
                        cell.setting = setting
                        return cell
                        
                    default:
                        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingRow.reuseIdentifier, for: indexPath) as? SettingRow else {
                            return UICollectionViewCell()
                        }
                        cell.setting = setting
                        return cell
                    }
                }
            } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                switch dataSource[indexPath.section] {
                case .setting(header: let header, items: _):
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SettingHeader.reuseIdentifier, withReuseIdentifier: SettingHeader.reuseIdentifier, for: indexPath) as? SettingHeader else { return UICollectionReusableView() }
                    headerView.text = header
                    return headerView
                default: return UICollectionReusableView()
                }
            }
        }
}
//MARK: - collectionViewLayout
extension MyPageViewController {
    private func generateLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(230)), subitem: item,count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            } else {
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(46))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width - 96),
                                                        heightDimension: .absolute(48))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: SettingHeader.reuseIdentifier, alignment: .topLeading)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48)
                
                section.interGroupSpacing = CGFloat(8)
                
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
    }
}

//MARK: - ProfileCellDelegate
extension MyPageViewController: ProfileCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                imageView.contentMode = .scaleAspectFit
//                imageView.image = pickedImage //4
//            }
//            dismiss(animated: true, completion: nil)
//        }
    
    func didTapEditProfileImage() {
        
    }
    
    func didTapEditProfileInfo() {
        
    }
    
    
}
