//
//  ViewController.swift
//  IOS-Swift-SpeechToText
//
//  Created by Pooya on 2018-08-29.
//  Copyright © 2018 Pooya. All rights reserved.
// tutorial bisa cek di https://www.youtube.com/watch?v=EhI4j5drcFI&t=61s


import UIKit
import Speech

class SpeechViewController: UIViewController {

    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var startStopBtn2: UIButton!
    @IBOutlet weak var segmentCtr: UISegmentedControl!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var labelresult1: UILabel!
    @IBOutlet weak var labelresult2: UILabel!
    @IBOutlet weak var labelwaitress: UILabel!
    @IBOutlet weak var labelyou1: UILabel!
    @IBOutlet weak var labelyou2: UILabel!
   
   
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR")) //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    var lang: String = "ko-KR"
    
    override func viewDidLoad() {
        
        var DailyQuiz = [String]()
        DailyQuiz.append("잠깐,여기 메뉴입니다 무엇을 주문 하시겠습니까?")
        DailyQuiz.append("이집에서 뭐가 제일 맛있습니까")
        DailyQuiz.append("네 갈비탕 일인분 주문하겠습니다")
        
        labelwaitress.text = DailyQuiz[0]
        labelyou1.text = DailyQuiz[1]
        labelyou2.text = DailyQuiz[2]
        
        super.viewDidLoad()
        startStopBtn.isEnabled = false  //2
        speechRecognizer?.delegate = self as? SFSpeechRecognizerDelegate  //3
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.startStopBtn.isEnabled = isButtonEnabled
            }
        }
    }

    @IBAction func segmentAct(_ sender: Any) {
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            lang = "en-US"
            break;
        case 1:
            lang = "ko-KR"
            break;
        default:
            lang = "ko-KR"
            break;
        }
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
    }
    
    @IBAction func startStopAct(_ sender: Any) {
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            startStopBtn.isEnabled = false
            startStopBtn.backgroundColor = .systemBlue
        } else {
            startRecording(button: startStopBtn)
            startStopBtn.backgroundColor = .green
            self.labelresult1.text = "listening"
            self.labelresult1.backgroundColor = .yellow
        }
    }
    
    @IBAction func startStop2Act(_ sender: Any) {
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            startStopBtn2.isEnabled = false
            startStopBtn2.backgroundColor = .systemBlue
        } else {
            startRecording(button: startStopBtn2)
            startStopBtn2.backgroundColor = .green
        }
    }
    
    
    func startRecording(button: UIButton) {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if button == self.startStopBtn {
            if result != nil {
                
                self.textView1.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if self.textView1.text == "이집에서 뭐가 제일 맛있습니까" {
                self.labelresult1.text = "excellent"
                self.labelresult1.backgroundColor = .green
                self.labelyou1.textColor = .green
            }
            
            else if self.textView1.text != "이집에서 뭐가 제일 맛있습니까"
            {
                self.labelresult1.text = "not bad"
                self.labelresult1.backgroundColor = .yellow
                self.labelyou1.textColor = .red
            }
            }
            
            else {
            if result != nil {
                
                self.textView2.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if self.textView2.text == "네 갈비탕 일인분 주문하겠습니다" {
                self.labelresult2.text = "excellent"
                self.labelresult2.backgroundColor = .green
                self.labelyou2.textColor = .green
            }
            
            else if self.textView2.text != "네 갈비탕 일인분 주문하겠습니다"
            {
                self.labelresult2.text = "not bad"
                self.labelresult2.backgroundColor = .yellow
                self.labelyou2.textColor = .red
            }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.startStopBtn.isEnabled = true
                self.labelresult1.backgroundColor = .blue
                self.labelresult1.text = "try again"
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        //textView1.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            startStopBtn.isEnabled = true
        } else {
            startStopBtn.isEnabled = false
        }
    }
    
    

}

