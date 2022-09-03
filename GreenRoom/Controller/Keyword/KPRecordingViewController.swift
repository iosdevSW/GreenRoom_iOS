//
//  PracticeInterviewViewController.swift
//  GreenRoom
//
//  Created by SangWoo's MacBook on 2022/08/28.
//

import UIKit
import AVFoundation
import Speech

class KPRecordingViewController: UIViewController{
    //MARK: - Properties
    let viewmodel: KeywordViewModel!
    var urls = [URL]()
    
    private let fileManager = FileManager.default
    private var captureSession: AVCaptureSession?
    private var captureDevice: AVCaptureDevice?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var moviFileOutput: AVCaptureMovieFileOutput!
    private let preView = UIView()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: .init(identifier: "ko-KR")) // 한국말 Recognizer 생성
    //음성인식요청을 처리하는 객체
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    //음성 인식 요청 결과를 제공하는 객체)
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let recordingButton = UIButton(type: .system).then {
        $0.setTitle("촬영", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }
    
    let testButton = UIButton(type: .system).then {
        $0.setTitle("중단", for: .normal)
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
        configureUI()
        setupCaptureSession()
    }
 
    //MARK: - Selector
    @objc func didClickRecordingButton(_ sender: UIButton) {
        startRecording() //녹화 녹음시작
    }
    
    @objc func didClickTestButton(_ sender: UIButton) {
        if moviFileOutput.isRecording {
            moviFileOutput.stopRecording()
        }
    }
    
    
    //MARK: - ConfigureUI
    func configureUI() {
        self.view.addSubview(preView)
        preView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.preView.addSubview(recordingButton)
        recordingButton.addTarget(self, action: #selector(didClickRecordingButton(_:)), for: .touchUpInside)
        recordingButton.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.width.height.equalTo(60)
        }
        
        self.preView.addSubview(testButton)
        testButton.addTarget(self, action: #selector(didClickTestButton(_:)), for: .touchUpInside)
        testButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(recordingButton.snp.centerY)
            make.width.height.equalTo(60)
        }
    }
}

//MARK: - AVFoundation 관련
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
            let audioDevice = try AVCaptureDevice.default(for: AVMediaType.audio)!
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
        DispatchQueue.main.async {
            self.videoPreviewLayer?.frame = self.preView.bounds
        }
               
        // preview까지 준비되었으니 captureSession을 시작하도록 설정
        
        startCaptureSession()
    }
    
    private func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    
    // Recording Methods
    private func startRecording() {
        moviFileOutput.startRecording(to: tempURL(), recordingDelegate: self)
    }
    
    private func tempURL()-> URL{
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
        
        return directoryURL.appendingPathComponent("test\(urls.count+1).mp4")    // 파일이 저장될 경로
    }
    
    //레코딩 시작시 호출
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("녹화시작")
    }
    
    //레코딩 끝날시 호출 시작할때 파라미터로 입력한 url 기반으로 저장 작업 수행
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("녹화종료")
        urls.append(outputFileURL)
        if urls.count == viewmodel.selectedQuestionTemp.count {
            if viewmodel.keywordOnOff{
                self.navigationController?.pushViewController(KPFinishViewController(viewmodel: viewmodel), animated: true)
            }else {
                viewmodel.videoURLs = urls
                self.navigationController?.pushViewController(KPDetailViewController(viewmodel: viewmodel), animated: true)
            }
            
        }
    }
}
