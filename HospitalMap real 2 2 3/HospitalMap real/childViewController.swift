//
//  ChildViewController.swift
//  HospitalMap real2
//
//  Created by 최지 on 02/06/2019.
//  Copyright © 2019 최지. All rights reserved.
//


import UIKit
import Speech

class ChildViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var yadmNm = NSMutableString()
    var addr = NSMutableString()
    
    var XPos = NSMutableString()
    var YPos = NSMutableString()
    
    var hospitalname = ""
    var hospitalname_utf8 = ""
    
    var Hpid = NSMutableString()
    
    func beginParsing(){
        posts = []
        //parser = XMLParser(contentsOf:(URL(string:url!))!)!
        // parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])  {
        element = elementName as NSString
        if ( elementName as NSString).isEqual(to: "item"){
            elements = NSMutableDictionary()
            elements = [:]
            yadmNm = NSMutableString()
            yadmNm = ""
            addr = NSMutableString()
            addr = ""
            
            XPos = NSMutableString()
            XPos = ""
            YPos = NSMutableString()
            YPos = ""
            Hpid = NSMutableString()
            Hpid = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "dutyName"){
            yadmNm.append(string)
        }else if element.isEqual(to: "dutyAddr"){
            addr.append(string)
        }
        else if element.isEqual(to: "wgs84Lon"){
            XPos.append(string)
        }
        else if element.isEqual(to: "wgs84Lat"){
            YPos.append(string)
        }else if element.isEqual(to: "hpid"){
            Hpid.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName as NSString).isEqual(to: "item"){
            if !yadmNm.isEqual(nil){
                elements.setObject(yadmNm, forKey: "yadmNm" as NSCopying)
            }
            if !addr.isEqual(nil){
                elements.setObject(addr, forKey: "addr" as NSCopying)
            }
            
            if !XPos.isEqual(nil){
                elements.setObject(XPos, forKey: "XPos" as NSCopying)
            }
            if !YPos.isEqual(nil){
                elements.setObject(YPos, forKey: "YPos" as NSCopying)
            }
            if !Hpid.isEqual(nil){
                elements.setObject(Hpid, forKey: "hpid" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphViewChild!
    @IBOutlet weak var counterView: CounterViewC!
    @IBOutlet weak var counterLabel: UILabel!
    // GraphView 볼 것인지 결정하는 변수
    var isGraphViewShowing = false
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        
        if(isGraphViewShowing) {
            // hide graph
            UIView.transition(from: graphView, to: counterView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
            // show graph
            UIView.transition(from: counterView, to: graphView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
            setupGraphDisplay()
        }
        isGraphViewShowing = !isGraphViewShowing
    }
    
    var for_graph_: Int = 0
    
    func setupGraphDisplay() {
        let maxDayIndex = stackView.arrangedSubviews.count - 1
        //  1- replace last day with today's actual data
        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
        // 2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        maxLabel.text = "\(graphView.graphPoints.max()!)"
        let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        // 4. - setup data formatter and calendar
        
        
        // 5. set up the day name labels with correct days
        for i in 0...maxDayIndex {
            if i == 0{
                if let label = stackView.arrangedSubviews[i] as? UILabel {
                    
                }
            }
            else if i == 1{
                if let label = stackView.arrangedSubviews[i] as? UILabel {
                    
                }
            }
            else if i == 2{
                if let label = stackView.arrangedSubviews[i] as? UILabel {
                    
                }
            }
            else if i == 3{
                if let label = stackView.arrangedSubviews[i] as? UILabel {
                    
                }
            }
            else if i == 4{
                if let label = stackView.arrangedSubviews[i] as? UILabel {
                    
                }
            }
            else if i == 5{
                if let label = stackView.arrangedSubviews[i] as? UILabel {
                   
                }
            }
            else if i == 6{
                if let label = stackView.arrangedSubviews[i] as? UILabel {
                    
                }
            }
            /*if let date = calendar.date(byAdding: .day, value: -i, to: today),
             let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
             label.text = formatter.string(from: date)
             }*/
        }
        
    }
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBAction func doneToPickerViewController(segue:UIStoryboardSegue){
    }
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    @IBAction func startTranscribing(_ sender: Any) {
        transcribeButton.isEnabled = false
        stopButton.isEnabled = true
        try! startSession()
    }
    @IBAction func stopTranscribing(_ sender: Any) {
        if audioEngine.isRunning{
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            transcribeButton.isEnabled = true
            stopButton.isEnabled = false
        }
        
        switch (self.myTextView.text){
        case "서울" : self.pickerView.selectRow(0, inComponent: 0, animated: true)
            break
        case "부산" : self.pickerView.selectRow(1, inComponent: 0, animated: true)
            break
        case "경기도" : self.pickerView.selectRow(2, inComponent: 0, animated: true)
            break
        case "충청북도" : self.pickerView.selectRow(3, inComponent: 0, animated: true)
            break
        case "전라북도" : self.pickerView.selectRow(4, inComponent: 0, animated: true)
            break
        case "경상남도" : self.pickerView.selectRow(5, inComponent: 0, animated: true)
            break
        case "경상북도" : self.pickerView.selectRow(6, inComponent: 0, animated: true)
            break
        case "강원도" : self.pickerView.selectRow(7, inComponent: 0, animated: true)
            break
        case "제주도" : self.pickerView.selectRow(8, inComponent: 0, animated: true)
            break
        default: break
        }
    }
    
    func startSession() throws {
        
        if let recognitionTask = speechRecognitionTask{
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        
        //let audioSession = AVAudioSession.sharedInstance()
        //try audioSession.setCategory(AVAudioSession.Category.record)
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else
        {fatalError("SFSpeechAufailed")}
        
        let inputNode = audioEngine.inputNode
        
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest){
            result, error in
            
            var finished = false
            
            if let result = result{
                self.myTextView.text = result.bestTranscription.formattedString
                finished = result.isFinal
            }
            
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                self.transcribeButton.isEnabled = true
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
            (buffer: AVAudioPCMBuffer, when: AVAudioTime)in
            self.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
    
    func authorizeSR(){
        
        SFSpeechRecognizer.requestAuthorization{authStatus in
            OperationQueue.main.addOperation {
                switch authStatus{
                case .authorized :
                    self.transcribeButton.isEnabled = true
                case .denied:
                    self.transcribeButton.isEnabled=false
                    self.transcribeButton.setTitle("Speech recognition access denied by user", for: .disabled)
                    
                case . restricted:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition restricted on device", for: .disabled)
                    
                case .notDetermined:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
        }
    }
    
    var pickerDataSource = ["서울","부산","경기도", "충청북도","전라북도", "경상남도","경상북도", "강원도", "제주도"]
    
    //보훈병원정보 OpenAPI 및 인증키
    //디폴트 시도코드 = 서울 (sideCd=110000)
    //ServiceKey = "sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D"
    var url : String = "http://apis.data.go.kr/B552657/HsptlAsembySearchService/getBabyListInfoInqire?serviceKey=9%2Fp4b%2Blim3NglmINIHv1qlKmh5A4VouFEu7pyqMAVrYzzJoIFNfM6w9t4nAd%2FHn9nIyvU3WusddtcbchFfHYiQ%3D%3D&Q0="
    
    var sgguCd : String = "서울특별시" //디폴트 시구코드 = 광진구
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0{
            sgguCd = "서울특별시"
        } else if row == 1{
            sgguCd = "부산광역시"
        } else if row == 2 {
            sgguCd = "경기도"
        }else if row == 3 {
            sgguCd = "충청북도"
        }else if row == 4 {
            sgguCd = "전라북도"
        }else if row == 5 {
            sgguCd = "경상남도"
        }else if row == 6 {
            sgguCd = "경상북도"
        }else if row == 7 {
            sgguCd = "강원도"
        }else if row == 8 {
            sgguCd = "제주특별자치도"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let childTableViewController = navController.topViewController as? ChildTableViewcontroller {
                    childTableViewController.url = url + sgguCd.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! /*+ "&Q1=" + sgguCd.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!*/
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        authorizeSR()
        // Do any additional setup after loading the view.
    }
    
    
}

