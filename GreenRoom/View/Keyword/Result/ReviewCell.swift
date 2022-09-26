//
//  ReviewCell.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/31.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class ReviewCell: UICollectionViewCell {
    //MARK: - Properties
    var recordingType: RecordingType = .camera
    
    var url: URL? {
        didSet{
            guard let url = url else { return}
            let item = AVPlayerItem(url: url)
            
            switch self.recordingType {
            case .camera:
                videoPlayer.replaceCurrentItem(with: item)
                addPeriodicTimeObserver()
            case .mike:
                audioRecordingSetting(url)
            }
        }
    }
    
    var totalTimeSecondsFloat: Float64 = 0
    var elapsedTimeSecondsFloat: Float64 = 0
    
    private var timer: Timer!
    
    private let videoPlayer = AVPlayer() // 녹화 다시보는 객체
    private var audioPlayer: AVAudioPlayer? // 녹음 다시듣는 객체
    
    private lazy var playerLayer = AVPlayerLayer(player: videoPlayer).then {
        self.frameView.layer.insertSublayer($0, at: 0)
        $0.videoGravity = .resizeAspectFill
        $0.cornerRadius = 15
        $0.masksToBounds = true
    }
    
    private let frameView = UIView().then {
//        $0.backgroundColor = .customGray
        $0.layer.cornerRadius = 15
    }
    
    private let lodingIndicator = LodingIndicator().then {
        $0.isHidden = true
    }
    
    let questionLabel = UILabel().then {
        $0.font = .sfPro(size: 16, family: .Regular)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    let categoryLabel = UILabel().then {
        $0.backgroundColor = .customGray
        $0.textColor = .darkGray
        $0.font = .sfPro(size: 12, family: .Semibold)
        $0.textAlignment = .center
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    let keywordPersent = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 16, family: .Semibold)
    }
    
    private let playButton = UIButton(type: .system).then {
        $0.layer.cornerRadius = 25
        $0.layer.masksToBounds = true
        $0.tintColor = .white
        $0.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    private lazy var playSlider = CustomSlider()
    
    private let elapsedSecondLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.font = .sfPro(size: 16, family: .Semibold)
        $0.text = "00:00 "
    }
    
    private let totalSecondLabel = UILabel().then {
        $0.textColor = .customGray
        $0.font = .sfPro(size: 12, family: .Regular)
        $0.text = "| 00:00"
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        self.playButton.addTarget(self, action: #selector(didClickPlayButton(sender:)), for: .touchUpInside)
        self.playSlider.addTarget(self, action: #selector(didChangeSlide), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.playerLayer.frame = self.frameView.bounds
        self.playButton.setGradient(
            color1: UIColor(red: 110/255.0, green: 234/255.0, blue: 174/255.0, alpha: 1.0),
            color2: UIColor(red: 87/255.0, green: 193/255.0, blue: 183/255.0, alpha: 1.0))
    }
    
    
    //MARK: - Method
    func updateTime() {
        guard let audioPlayer = self.audioPlayer else { return }
    
        elapsedSecondLabel.text = "\(convertTime(seconds: Float(audioPlayer.currentTime))) "
        
        totalSecondLabel.text = "| \(convertTime(seconds: Float(audioPlayer.duration)))"
        
        self.playSlider.value = Float(audioPlayer.currentTime / audioPlayer.duration)
    }
    
    func addPeriodicTimeObserver() {
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
        
        self.videoPlayer.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] elapsedTime in
            let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedTime)
            let totalTimeSecondsFloat = CMTimeGetSeconds(self?.videoPlayer.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
            
            guard
                !elapsedTimeSecondsFloat.isNaN,
                !elapsedTimeSecondsFloat.isInfinite,
                !totalTimeSecondsFloat.isNaN,
                !totalTimeSecondsFloat.isInfinite
            else { return }
            
            // 초 저장
            self?.totalTimeSecondsFloat = totalTimeSecondsFloat
            self?.elapsedTimeSecondsFloat = elapsedTimeSecondsFloat
            
            //slider 값 변경
            self?.playSlider.value = Float(elapsedTimeSecondsFloat / totalTimeSecondsFloat)

            // label 표시
            self?.elapsedSecondLabel.text = "\(self!.convertTime(seconds: Float(elapsedTimeSecondsFloat))) "
            self?.totalSecondLabel.text = "| \(self!.convertTime(seconds: Float(totalTimeSecondsFloat)))"
            
            if elapsedTimeSecondsFloat == totalTimeSecondsFloat {
                self?.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                self?.elapsedTimeSecondsFloat = 0
                self?.videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
            }
        }
    }
    
    func convertTime(seconds: Float)-> String {
        let seconds = Int(floor(seconds))
        
        let second = seconds % 60
    
        let minute = seconds / 60
        
        return "\(String(format: "%02d:", minute))\(String(format: "%02d", second))"
    }
    
    func audioRecordingSetting(_ url: URL){
        lodingIndicator.isHidden = false
        
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
        self.audioPlayer?.delegate  = self
        let audioSession = AVAudioSession.sharedInstance()
        
        self.audioPlayer?.volume = 1.0
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setMode(.moviePlayback)
            try audioSession.setActive(true)

        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        audioPlayer?.prepareToPlay()
    }
    
    func audioRecordingPlay() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.pause()
            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            self.lodingIndicator.stopAnimating()
            timer.invalidate()
        } else {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
                self.updateTime()
            })
            audioPlayer?.play()
            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            self.lodingIndicator.startAnimating()
            timer.fire()
        }
        
        
    }
    
    func videoRecordingPlay() {
        switch self.videoPlayer.timeControlStatus {
        case .paused:
            self.videoPlayer.play()
            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        case .playing:
            self.videoPlayer.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        default:
            break
        }
    }
    
    
    //MARK: - Selector
    @objc func didClickPlayButton(sender: UIButton) {
        switch recordingType {
        case .camera : self.videoRecordingPlay()
        case .mike : self.audioRecordingPlay()
        }
    }
    
    @objc private func didChangeSlide() {
        switch recordingType {
        case .camera:
            self.elapsedTimeSecondsFloat = Float64(self.playSlider.value) * self.totalTimeSecondsFloat
            self.videoPlayer.seek(to: CMTimeMakeWithSeconds(self.elapsedTimeSecondsFloat, preferredTimescale: Int32(NSEC_PER_SEC)))
        case .mike:
            guard let audioPlayer = audioPlayer else { return }
            
            let playTime = TimeInterval(playSlider.value) * audioPlayer.duration
            audioPlayer.currentTime = playTime
            self.updateTime()
        }
    }
    
    
    //MARK: - ConfigureUI
    func configureUI() {
        self.addSubview(self.frameView)
        self.frameView.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().offset(-28)
            make.height.equalTo(500)
        }
        
        self.addSubview(self.keywordPersent)
        self.keywordPersent.snp.makeConstraints{ make in
            make.top.equalTo(frameView.snp.bottom).offset(28)
            make.trailing.equalToSuperview().offset(-44)
        }
        
        self.addSubview(self.questionLabel)
        self.questionLabel.snp.makeConstraints{ make in
            make.top.equalTo(frameView.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(44)
            make.trailing.equalTo(self.keywordPersent.snp.leading).offset(-10)
            
        }
        
        self.addSubview(self.categoryLabel)
        self.categoryLabel.snp.makeConstraints{ make in
            make.top.equalTo(self.questionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(44)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        
        self.frameView.addSubview(self.playSlider)
        self.playSlider.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-14)
            make.height.equalTo(16)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        self.frameView.addSubview(self.playButton)
        self.playButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(12)
            make.height.width.equalTo(50)
            make.bottom.equalTo(playSlider.snp.top).offset(-12)
        }
        
        self.frameView.addSubview(self.elapsedSecondLabel)
        self.elapsedSecondLabel.snp.makeConstraints{ make in
            make.leading.equalTo(self.playButton.snp.trailing).offset(10)
            make.bottom.equalTo(self.playButton.snp.bottom)
        }
        
        self.frameView.addSubview(self.totalSecondLabel)
        self.totalSecondLabel.snp.makeConstraints{ make in
            make.leading.equalTo(self.elapsedSecondLabel.snp.trailing)
            make.bottom.equalTo(self.playButton.snp.bottom).offset(-2)
        }
        
        self.frameView.addSubview(self.lodingIndicator)
        self.lodingIndicator.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.width.height.equalTo(48)
        }
    }
}

//MARK: - AVAudioPlayerDelegate
extension ReviewCell: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer.invalidate()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        self.lodingIndicator.stopAnimating()
    }
}
