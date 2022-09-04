//
//  KPPrepareViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/24.
//

import UIKit
import RxSwift
import SwiftUI

class KPPrepareViewController: BaseViewController{
    //MARK: - Properties
    let viewmodel: KeywordViewModel
    var tempQuestionStorage: [String]?
    
    var goalFrameView = UIView().then {
        $0.backgroundColor = .customGray.withAlphaComponent(0.05)
        $0.layer.cornerRadius = 16
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
    }
    
    var goalProgressBarView = ProgressBarView()
    
    let questionsTableView = UITableView().then {
        $0.register(PracticeQuestionCell.self, forCellReuseIdentifier: "PracticeQuestionCell")
        $0.backgroundColor = .white
    }
    
    let recordFrameView = UIView().then {
        $0.backgroundColor = .mainColor.withAlphaComponent(0.3)
    }
    
    let recordButton = UIButton().then {
        $0.setImage(UIImage(named: "record"), for: .normal)
        $0.tintColor = .white
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 50
        $0.layer.borderWidth = 5
    }
    
    let cameraOnOffSwitch = CustomSwitch()

    //MARK: - Init
    init(viewmodel: KeywordViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setGesutre()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        self.recordButton.setGradient(
            color1: UIColor(red: 110/255.0, green: 234/255.0, blue: 174/255.0, alpha: 1.0),
            color2: UIColor(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1.0))
    }
    
    override func viewDidLayoutSubviews() {
        self.cameraOnOffSwitch.setGradient(color1: UIColor(red: 110/255.0, green: 234/255.0, blue: 174/255.0, alpha: 1.0),
                                           color2: UIColor(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1.0))
    }
    
    //MARK: - Bind
    override func setupBinding() {
        viewmodel.selectedQuestionObservable
            .bind(to: self.questionsTableView.rx.items(cellIdentifier: "PracticeQuestionCell",
                                                       cellType: PracticeQuestionCell.self)) { index, title, cell in
                cell.numberLabel.text = "질문\(index+1)"
                cell.titleLabel.text = title
                cell.selectionStyle = .none
                cell.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
                
                let btn = UIButton()
                btn.setImage(UIImage(named: "menu"), for: .normal)
                btn.tintColor = .customGray
                let imageView = UIImageView(image: UIImage(named: "menu"))
                imageView.tintColor = .customGray
                btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                cell.accessoryView = btn
            }.disposed(by: disposeBag)
    }

    //MARK: - Gesture
    func setGesutre() {
        // 1. 테이블뷰에 롱프레시 제스쳐 추가 ( 셀 순서 변경 위해)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressCalled(gestureRecognizer:)))
            questionsTableView.addGestureRecognizer(longPressGesture)
    }
    
    //MARK: - Method
    // row를 드래그할 때 선택한 row를 스냅샷찍어 같이 움직이게함
    func snapShotOfCall(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0) //스냅샷 시작 옵션
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!) // 스냅샷
        
        let image = UIGraphicsGetImageFromCurrentImageContext()! // 가져오기
        UIGraphicsEndImageContext() // 스냅샷 종료
            
        let cellSnapshot: UIView = UIImageView(image: image)

        return cellSnapshot
    }
    
    
    //MARK: - Selector
    @objc func didClickRecordButton(_ sender: UIButton){
        let per = goalProgressBarView.progressBar.progress
        viewmodel.goalPersent = per
        self.navigationController?.pushViewController(KPRecordingViewController(viewmodel: viewmodel), animated: true)
    }
    
    @objc func didChangeCameraIsOnValue(_ sender: UIControl) {
        guard let cameraSwitch = sender as? CustomSwitch else { return }
        viewmodel.cameraOnOff = cameraSwitch.isOn
        print("camera On/Off : \(cameraSwitch.isOn)")
    }

    
    //MARK: - ConfigureUI
    override func configureUI(){
        self.view.addSubview(self.goalFrameView)
        self.goalFrameView.addSubview(self.goalProgressBarView)
        
        self.goalFrameView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(276)
        }
        
        self.goalProgressBarView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.goalFrameView.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.view.addSubview(self.recordFrameView)
        self.recordFrameView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(93)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        self.view.addSubview(self.questionsTableView)
        if viewmodel.keywordOnOff { // on
            self.questionsTableView.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(self.goalFrameView.snp.bottom).offset(15)
                make.bottom.equalTo(self.recordFrameView.snp.top)
            }
        } else { // off
            self.goalFrameView.isHidden = true
            self.questionsTableView.snp.makeConstraints{ make in
                make.leading.equalToSuperview().offset(24)
                make.trailing.equalToSuperview().offset(-24)
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(self.recordFrameView.snp.top)
            }
        }
        
        self.recordFrameView.addSubview(self.recordButton)
        self.recordButton.addTarget(self, action: #selector(didClickRecordButton(_:)), for: .touchUpInside)
        self.recordButton.snp.makeConstraints{ make in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        _ = UILabel().then {
            $0.text = "카메라 설정"
            $0.textColor = .customDarkGray
            $0.font = .sfPro(size: 16, family: .Semibold)
            
            self.recordFrameView.addSubview($0)
            $0.snp.makeConstraints{ make in
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview().multipliedBy(0.4)
            }
        }
        
        self.recordFrameView.addSubview(self.cameraOnOffSwitch)
        self.cameraOnOffSwitch.addTarget(self, action: #selector(didChangeCameraIsOnValue(_:)), for: .valueChanged)
        self.cameraOnOffSwitch.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.6)
            make.width.equalTo(86)
            make.height.equalTo(36)
        }
    }
}

//MARK: - LongPress Gesture
extension KPPrepareViewController {
    @objc func longPressCalled(gestureRecognizer: UIGestureRecognizer) {
        guard let longPress = gestureRecognizer as? UILongPressGestureRecognizer else { return }
        // 제스쳐의 상태를 입력받음 began(롱프레스시작) changed(눌려진상태) ended(뗀 상태)
        let state = longPress.state
        let locationInView = longPress.location(in: questionsTableView) //테이블 뷰에서의 CGPoint
        let indexPath = questionsTableView.indexPathForRow(at: locationInView) // 해당Point의 indexPath 구하기.
        
        // 최초 indexPath 변수
        struct Initial {
            static var initialIndexPath: IndexPath?
        }
        
        // 스냅샷
        struct MyCell {
            static var cellSnapshot: UIView?
            static var cellIsAnimating: Bool = false
            static var cellNeedToShow: Bool = false
        }
        
        // UIGestureRecognizer 상태에 따른 case 분기처리
        switch state {
            
        // longPress 제스처가 시작할 때 case ( 처음 길게 눌려 인식 시작 )
        // 눌려진 셀 스냅샷을 따고 투명하게 만들어줌
        case UIGestureRecognizer.State.began:
            if indexPath != nil {
                Initial.initialIndexPath = indexPath // 첫 indexpath
                
                let cell = questionsTableView.cellForRow(at: indexPath!)
                
                MyCell.cellSnapshot = snapShotOfCall(cell!)
                
                var center = cell?.center
                MyCell.cellSnapshot!.center = center!
                
                questionsTableView.addSubview(MyCell.cellSnapshot!)
                
                if tempQuestionStorage == nil {
                    tempQuestionStorage = viewmodel.selectedQuestionTemp
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    MyCell.cellIsAnimating = true
                    MyCell.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05) // 꾹 누른 스냅샷 1.05배 확대
                    cell?.alpha = 0.0 // 원래 처음 꾹 누른 부분의 기존 row는 가려줌
                }, completion: { (finished) -> Void in
                    if finished {
                        MyCell.cellIsAnimating = false
                        if MyCell.cellNeedToShow { // 0.25초 안에 뗀 경우 실행
                            MyCell.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else { // 0.25초 안에 떼지 않은경우 기존 셀 숨김
                            cell?.isHidden = true
                        }
                    }
                })
            }
            // longPress 제스처가 변경될 때 case
        case UIGestureRecognizer.State.changed:
            if MyCell.cellSnapshot != nil {
                var center = MyCell.cellSnapshot!.center
                center.y = locationInView.y
                MyCell.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Initial.initialIndexPath)) && Initial.initialIndexPath != nil {
                    // 메모리 관련 이슈때문에 바꿔준 부분
                    
                    guard var items = self.tempQuestionStorage else { return }
                    items.insert(items.remove(at: Initial.initialIndexPath!.row), at: indexPath!.row)
                    questionsTableView.moveRow(at: Initial.initialIndexPath!, to: indexPath!)
                    self.tempQuestionStorage = items
                    Initial.initialIndexPath = indexPath
                }
            }
            // longPress 제스처가 끝났을 때 case
        default:
            if Initial.initialIndexPath != nil {
                let cell = questionsTableView.cellForRow(at: Initial.initialIndexPath!)
                if MyCell.cellIsAnimating {
                    MyCell.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    MyCell.cellSnapshot!.center = (cell?.center)!
                    MyCell.cellSnapshot!.transform = CGAffineTransform.identity
                    MyCell.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        self.viewmodel.selectedQuestionTemp = self.tempQuestionStorage!
                        self.tempQuestionStorage = nil
                        Initial.initialIndexPath = nil
                        MyCell.cellSnapshot!.removeFromSuperview()
                        MyCell.cellSnapshot = nil
                    }
                })
            }
        }
    }
}
