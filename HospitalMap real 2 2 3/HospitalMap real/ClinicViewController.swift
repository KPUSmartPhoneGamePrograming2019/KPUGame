//
//  ClinicViewController.swift
//  HospitalMap real2
//
//  Created by 최지 on 02/06/2019.
//  Copyright © 2019 최지. All rights reserved.
//

import UIKit
import Speech
@IBDesignable

class ClinicViewController: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource,UIScrollViewDelegate,XMLParserDelegate {
    
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
        parser.delegate = self
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
    // label outlets
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var counterView: CounterView!
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
        //  1- replace last day with today's actual data
        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
        // 2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        maxLabel.text = "\(graphView.graphPoints.max()!)"
        let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        // 4. - setup data formatter and calendar
        
    }
    
    
    @IBAction func pushButtonPresse(_ button: PushButtonView){
        if button.isAddButton{
            if counterView.counter < 99 {
                counterView.counter += 1
            }
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
        // graphview 상태에서 플러스 버튼 누르면 counterview 상태로 돌아간다.
        if isGraphViewShowing {
            counterViewTap(nil)
        }
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    
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
        case "광진구" : self.pickerView.selectRow(0, inComponent: 0, animated: true)
        imageView.image = UIImage(named: "광진구")!
        for_graph_ = 0
            break
        case "구로구" : self.pickerView.selectRow(1, inComponent: 0, animated: true)
        imageView.image = UIImage(named: "구로구")!
        for_graph_ = 1
            break
        case "동대문구" : self.pickerView.selectRow(2, inComponent: 0, animated: true)
        imageView.image = UIImage(named: "동대문구")!
        for_graph_ = 2
            break
        case "종로구" : self.pickerView.selectRow(3, inComponent: 0, animated: true)
        imageView.image = UIImage(named: "종로구")!
        for_graph_ = 3
            break
        case "강남구" : self.pickerView.selectRow(4, inComponent: 0, animated: true)
            break
        case "동작구" : self.pickerView.selectRow(5, inComponent: 0, animated: true)
            break
        case "관악구" : self.pickerView.selectRow(6, inComponent: 0, animated: true)
            break
        case "강서구" : self.pickerView.selectRow(7, inComponent: 0, animated: true)
            break
        case "양천구" : self.pickerView.selectRow(8, inComponent: 0, animated: true)
            break
        case "영등포구" : self.pickerView.selectRow(9, inComponent: 0, animated: true)
            break
        case "금천구" : self.pickerView.selectRow(10, inComponent: 0, animated: true)
            break
        case "서초구" : self.pickerView.selectRow(11, inComponent: 0, animated: true)
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
    
    var pickerDataSource = ["광진구","구로구","동대문구","종로구", "강남구", "동작구", "관악구","강서구","양천구","영등포구","금천구","서초구"]
    
    //보훈병원정보 OpenAPI 및 인증키
    //디폴트 시도코드 = 서울 (sideCd=110000)
    //ServiceKey = "sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D"
    var url : String = "http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyListInfoInqire?ServiceKey=9%2Fp4b%2Blim3NglmINIHv1qlKmh5A4VouFEu7pyqMAVrYzzJoIFNfM6w9t4nAd%2FHn9nIyvU3WusddtcbchFfHYiQ%3D%3D&numOfRows=999&Q0="
    
    var location_sggucd : String = "서울특별시"
    var sgguCd : String = "광진구" //디폴트 시구코드 = 광진구
    
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
        
        scrollView.setZoomScale(CGFloat(signOf: 0,magnitudeOf: 0), animated: false)
        
        if row == 0{
            sgguCd = "광진구"
            imageView.image = UIImage(named: "광진구")!
            for_graph_ = 0
        } else if row == 1{
            sgguCd = "구로구"
            imageView.image = UIImage(named: "구로구")!
            for_graph_ = 1
        } else if row == 2 {
            sgguCd = "동대문구"
            imageView.image = UIImage(named: "동대문구")!
            for_graph_ = 2
        }else if row == 3 {
            sgguCd = "종로구"
            imageView.image = UIImage(named: "종로구")!
            for_graph_ = 3
        }else if row == 4 {
            sgguCd = "강남구"
            imageView.image = UIImage(named: "강남구")!
            for_graph_ = 4
        }else if row == 5 {
            sgguCd = "동작구"
        }else if row == 6 {
            sgguCd = "관악구"
        }else if row == 7 {
            sgguCd = "강서구"
        }else if row == 8 {
            sgguCd = "양천구"
        }else if row == 9 {
            sgguCd = "영등포구"
        }else if row == 10 {
            sgguCd = "금천구"
        }else if row == 11 {
            sgguCd = "서초구"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToTableView" {
            if let navController = segue.destination as? UINavigationController {
                if let clinicTableViewController = navController.topViewController as? ClinicTableViewController {
                    clinicTableViewController.url = url + location_sggucd.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! + "&Q1=" + sgguCd.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                }
            }
        }
    }
    
    
    func centerScrollViewContents(){
        let boundsSize = scrollView.bounds.size
        var contensFrame = imageView.frame
        
        if contensFrame.size.width < boundsSize.width{
            contensFrame.origin.x = (boundsSize.width - contensFrame.size.width) / 2.0
        }else{
            contensFrame.origin.x = 0.0
        }
        if contensFrame.size.height < boundsSize.height{
            contensFrame.origin.y = (boundsSize.height - contensFrame.size.height) / 2.0
        }else{
            contensFrame.origin.y = 0.0
        }
        imageView.frame = contensFrame
    }
    
    @objc func scrollViewDoubleTapped(_ recognizer: UITapGestureRecognizer){
        let pointInView = recognizer.location(in: imageView)
        
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        if ( imageView.image == UIImage(named: "광진구")!){
            imageView.image = UIImage(named: "광진구2")!
        }
        else if ( imageView.image == UIImage(named: "광진구2")!){
            imageView.image = UIImage(named: "광진구3")!
        }
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRect(x:x,y:y,width: w,height: h)
        
        scrollView.zoom(to: rectToZoomTo, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView){
        centerScrollViewContents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        authorizeSR()
        
        let image = UIImage(named: "광진구")!
        
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x:0,y:0), size: image.size)
        scrollView.addSubview(imageView)
        
        scrollView.contentSize = image.size
        
        let doubleTapRecognizer =  UITapGestureRecognizer(target: self, action: #selector(ViewController.scrollViewDoubleTapped(_:)))
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth,scaleHeight)
        scrollView.minimumZoomScale = minScale
        
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
        // Do any additional setup after loading the view.
    }

}
