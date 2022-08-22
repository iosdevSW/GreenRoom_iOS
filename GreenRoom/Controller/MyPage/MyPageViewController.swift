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
import PhotosUI

final class MyPageViewController: UIViewController {
    
    private var viewModel: MyPageViewModel
    private var disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView!
    private let imagePickerView = UIImagePickerController()
    
    //MARK: - Lifecycle
    init(viewModel: MyPageViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.isHidden = true
    }
    //MARK: - Configure
    private func configureUI(){

        view.backgroundColor = .backgroundGary
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
        
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(MyPageSectionModel.Item.self))
            .subscribe(onNext: { [weak self] indexPath, item in
                guard let self = self else { return }
                
                switch item {
                case .setting(settingInfo: let info):
                    switch info.setting {
                        
                    case .QNA:
                        let vc = QNAViewController(viewModel: self.viewModel)
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .FAQ:
                        let vc = FAQViewController(viewModel: self.viewModel)
                        self.navigationController?.pushViewController(vc, animated: true)
                    default: return 
                    }
                default : return
                }
            }).disposed(by: disposeBag)
    }
}

//MARK: - CollectionViewDataSoruce
extension MyPageViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<MyPageSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MyPageSectionModel> {
            dataSource, collectionView, indexPath, item in
            switch item {
                
            case .profile(profileInfo: let user) :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.reuseIdentifier, for: indexPath) as? ProfileCell else {
                    return UICollectionViewCell()
                }
                cell.user = user
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
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.width),
                                                        heightDimension: .absolute(48))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: SettingHeader.reuseIdentifier, alignment: .topLeading)
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.interGroupSpacing = CGFloat(8)
                
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            }
        }
    }
}

//MARK: - ProfileCellDelegate
extension MyPageViewController: ProfileCellDelegate, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        viewModel.profileImageObservable.onNext(newImage)// 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    }
    
    //MARK: - PHPickerView
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let image = image as? UIImage else { return }
                print(image)
                self?.viewModel.profileImageObservable.onNext(image)
            }
        }
    }
    
    func didTapEditProfileImage() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = .mainColor
        
        actionSheet.addAction(UIAlertAction(title: "사진 선택", style: .default) { [weak self] _ in
            self?.didTapopenGallery()
        })
        
        actionSheet.addAction(UIAlertAction(title: "사진 찍기", style: .default) { [weak self] _ in
            self?.didTapOpenCamera()
        })
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    
    func didTapOpenCamera() {
        
        imagePickerView.delegate = self
        imagePickerView.sourceType = .camera
        present(imagePickerView,animated: true)
    }
    
    func didTapopenGallery(){
        
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            let PHPcikerView = PHPickerViewController(configuration: configuration)
            PHPcikerView.delegate = self
            self.present(PHPcikerView, animated: true)
        } else {
            imagePickerView.delegate = self
            imagePickerView.sourceType = .savedPhotosAlbum
            present(imagePickerView,animated: true)
        }
    }
    
    func didTapEditProfileInfo() {
        let vc = EditProfileInfoViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
