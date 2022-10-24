//
//  PracticeInterviewViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/28.
//
// 메모리 누수 발생.. 어딜까..
import UIKit
import AVFoundation
import Speech

final class KPRecordingViewController: BaseViewController{
    //MARK: - Properties
    private let viewmodel: KeywordViewModel!
    
    private var player: AVAudioPlayer?
    
    private let fileManager = FileManager.default
    
    // 녹화를 위한 객체
    private var captureSession: AVCaptureSession?
    private var captureDevice: AVCaptureDevice?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var moviFileOutput: AVCaptureMovieFileOutput!
    
    // 녹음을 위한 객체
    private var audioRecorder: AVAudioRecorder?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: .init(identifier: "ko-KR")) // 한국말 Recognizer 생성
    
    //음성인식요청을 처리하는 객체
    private var recognizerRequest: SFSpeechURLRecognitionRequest?
    
    private let preView = UIView()
    
    private let darkView = CustomDarkView()
    
    private let questionLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .sfPro(size: 22, family: .Semibold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let keywordLabel = UILabel().then {
        $0.textColor = .mainColor
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .sfPro(size: 22, family: .Semibold)
    }
    
    private let recordingButton = CustomRecordingButton(type: .system).then {
        $0.setTitle("촬영", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }
    
    //MARK: - Init
    init(viewmodel: KeywordViewModel){
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setNavigationFAQItem()
        self.configureNavigationBackButtonItem()
        
        switch self.viewmodel.recordingType {
        case .camera: setupCaptureSession()
        case .mike: setupAVAudio()
        }
        
        self.keywordLabel.isHidden = true
        self.questionLabel.isHidden = true
        self.recordingButton.isHidden = true
        self.darkView.keywordLabel.isHidden = self.viewmodel.keywordOnOff.value == true ? false : true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Bind
    override func setupBinding() {
        viewmodel.URLs
            .filter{ [weak self] in $0.count < self!.viewmodel.selectedQuestions.value.count}
            .bind(onNext: { [weak self] urls in
                guard let self = self else { return }
                let question = self.viewmodel.selectedQuestions.value[urls.count]
                
                self.darkView.questionLabel.text = "Q\(urls.count+1)\n\n\(question.question)"
                self.darkView.keywordLabel.text  = question.keyword.joined(separator: "  ")
                self.questionLabel.text = "Q\(urls.count+1)\n\n\(question.question)"
                self.keywordLabel.text = question.keyword.joined(separator: "  ")
            }).disposed(by: disposeBag)
        
        viewmodel.URLs
            .filter{ [weak self] in $0.count <= self!.viewmodel.selectedQuestions.value.count && $0.count >= 1}
            .bind(onNext: { [weak self] urls in
                guard let self = self else { return }
                guard let url = urls.last else { return }
                
                if urls.count == self.viewmodel.selectedQuestions.value.count {
                    let indicatorView = LodingIndicator(frame: self.view.frame)
                    indicatorView.backgroundColor = .white
                    indicatorView.startAnimating()
                    self.view.addSubview(indicatorView)
                }
                self.speechToText(url)
            }).disposed(by: disposeBag)
        
        viewmodel.STTResult
            .filter{ !$0.isEmpty }
            .bind(onNext: { [weak self] result in
                guard let stt = result.last else { return }
                guard let self = self else { return }
                
                let persent = self.returnPersent(stt)
                var questions = self.viewmodel.selectedQuestions.value
    
                questions[result.count-1].sttAnswer = stt
                questions[result.count-1].persent = persent
                
                self.viewmodel.selectedQuestions.accept(questions)
        
                let totalPersent = self.viewmodel.selectedQuestions.value.map{ $0.persent ?? 0.0 }.reduce(CGFloat(0),+) / CGFloat(self.viewmodel.selectedQuestions.value.count)
                
                self.viewmodel.totalPersent.accept(totalPersent)
                
                if self.viewmodel.selectedQuestions.value.count == result.count {
                    if self.viewmodel.keywordOnOff.value{
                        self.navigationController?.pushViewController(KPFinishViewController(viewmodel: self.viewmodel), animated: true)
                    }else {
                        self.navigationController?.pushViewController(KPDetailViewController(viewmodel: self.viewmodel), animated: true)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Selector
    @objc func didClickRecordingButton(_ sender: UIButton) {
        switch viewmodel.recordingType {
        case .camera : self.videoRecording()
        case .mike: self.audioRecording()
        }
    }
    
    //MARK: - Method
    // 비디오 녹화시
    func videoRecording() {
        if moviFileOutput.isRecording {
            moviFileOutput.stopRecording() //녹화 중단
            recordingTrriger(isRecording: true)
        } else {
            recordingTrriger(isRecording: false)
            startRecording() //녹화 녹음시작
        }
    }
    
    // 오디오 녹화시
    private func audioRecording() {
        if let recorder: AVAudioRecorder = self.audioRecorder {
            if recorder.isRecording { // 현재 녹음 중이므로, 녹음 정지
                recorder.stop()
                recordingTrriger(isRecording: true)
            } else { // 녹음 시작
                recorder.record()
                recordingTrriger(isRecording: false)
            }
        }
    }
    
    private func recordingTrriger(isRecording: Bool){
        self.darkView.isHidden = !isRecording
        self.keywordLabel.isHidden = isRecording
        self.questionLabel.isHidden = isRecording
        self.recordingButton.isHidden = isRecording
        if !isRecording {
            self.keywordLabel.isHidden = self.viewmodel.keywordOnOff.value == true ? false : true
        }
    }
    
    // STT 실행
    private func speechToText(_ url: URL) {
        self.recognizerRequest = SFSpeechURLRecognitionRequest(url: url)
        
        _ = self.speechRecognizer?.recognitionTask(with: recognizerRequest!) { [weak self]( result, error) in
            guard let self = self else { return }
            guard let result = result else {
                var sttResults = self.viewmodel.STTResult.value
                sttResults.append("변환된 내용 없음")
                self.viewmodel.STTResult.accept(sttResults)
                
                return
            }
            
            let stt = result.bestTranscription.formattedString
            if result.isFinal {
                self.viewmodel.STTResult
                    .take(1)
                    .bind(onNext: { sttResults in
                        var results = sttResults
                        results.append(stt)
                        self.viewmodel.STTResult.accept(results)
                    }).disposed(by: self.disposeBag)
                self.recognizerRequest = nil
            }
        }
    }
    
    private func saveURL(_ url: URL) {
        // 길게 녹화할경우 음성이 녹음 안되는 현상이 있음 (이유 찾아 고쳐야함) 2번의 오류도 1번이 해결되면 해결될 가능성 있음
        // 녹화일 경우 mp4 -> m4a로 변환이 필요함 ( 영상이 십몇초를 넘을경우 변환이 안되는 오류 )
        self.viewmodel.URLs
            .filter{ $0.count < self.viewmodel.selectedQuestions.value.count }
            .take(1)
            .bind(onNext: { [weak self] urls in
                var urls = urls
                urls.append(url)
                self?.viewmodel.URLs.accept(urls)
            }).disposed(by: disposeBag)
    }
    
    private func returnPersent(_ stt: String)->CGFloat {
        var count = 0
        
        let keywords = self.viewmodel.selectedQuestions.value[self.viewmodel.URLs.value.count-1].keyword
        for keyword in keywords {
            if stt.contains(keyword) {
                count += 1
            }
        }
        
        return CGFloat(count)/CGFloat(keywords.count)
    }
    
    //MARK: - ConfigureUI
    override func configureUI() {
        self.view.addSubview(preView)
        preView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.preView.addSubview(self.darkView)
        self.darkView.startButton.addTarget(self, action: #selector(didClickRecordingButton(_:)), for: .touchUpInside)
        self.darkView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.preView.addSubview(recordingButton)
        recordingButton.addTarget(self, action: #selector(didClickRecordingButton(_:)), for: .touchUpInside)
        recordingButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-47)
            make.width.height.equalTo(84)
        }
        
        self.preView.addSubview(self.questionLabel)
        self.questionLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(77)
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }

        self.preView.addSubview(self.keywordLabel)
        self.keywordLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(self.recordingButton.snp.top).offset(-46)
            make.leading.equalToSuperview().offset(56)
            make.trailing.equalToSuperview().offset(-56)
        }
    }
}

//MARK: - AVFoundation (녹화)관련
extension KPRecordingViewController: AVCaptureFileOutputRecordingDelegate {
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo // set resoultion
        
        let cameras = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInTrueDepthCamera , .builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .front
        )
        
        let camera = cameras.devices.filter{ $0.position == .front }.first! // 전방 카메라
        
        captureDevice = camera
        
        do {
            //오디오 장치
            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession!.canAddInput(audioInput){
                captureSession?.addInput(audioInput)
            }
            
            //비디오 장치
            let videoInput = try AVCaptureDeviceInput(device: camera)
            moviFileOutput = AVCaptureMovieFileOutput()
            if captureSession!.canAddInput(videoInput) && captureSession!.canAddOutput(moviFileOutput) {
                captureSession?.addInput(videoInput)
                captureSession?.addOutput(moviFileOutput)
                // 여기에서 preview 세팅하는 함수 호출
                setupLivePreview()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupLivePreview() {
        // previewLayer 세팅
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        
        // UIView객체인 preView 위 객체 입힘
        preView.layer.insertSublayer(videoPreviewLayer!, at: 0)  // 맨 앞(0번쨰로)으로 가져와서 보이게끔 설정
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.videoPreviewLayer?.frame = self.preView.bounds
        }
        
        // preview까지 준비되었으니 captureSession을 시작하도록 설정
        startCaptureSession()
    }
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    // Recording Methods
    private func startRecording() {
        moviFileOutput.startRecording(to: tempURL(extn: "mp4"), recordingDelegate: self)
    }
    
    private func tempURL(extn: String)-> URL{
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let directoryURL = tempDirectoryURL.appendingPathComponent("NewDirectory")
        
        // 폴더 없으면 폴더 생성
        if !fileManager.fileExists(atPath: directoryURL.path){
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: false)
            }catch let error {
                print(error.localizedDescription)
            }
        }
        
        return directoryURL.appendingPathComponent("recordingFile\(self.viewmodel.URLs.value.count+1).\(extn)")    // 파일이 저장될 경로
    }
    
    //레코딩 시작시 호출
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("녹화시작")
    }
    
    //레코딩 끝날시 호출 시작할때 파라미터로 입력한 url 기반으로 저장 작업 수행
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        self.saveURL(outputFileURL)
        print("녹화종료")
    }
}

//MARK: - AVFoundation (녹음)관련
extension KPRecordingViewController: AVAudioRecorderDelegate {
    private func setupAVAudio(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true)
                                         
        } catch let error{
            print("Failed to set audio session category")
            print(error.localizedDescription)
        }
        
        let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey: 320_000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44_100.0,
            ]

        self.audioRecorder = try? AVAudioRecorder(url: tempURL(extn: "m4a"), settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.prepareToRecord()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.saveURL(recorder.url)
    }
}
