//
//  CounterLabelView.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 12..
//  Copyright © 2018년 Caroline. All rights reserved.
//

import UIKit
//UILabel을 상속받는 class
class CounterLabelView: UILabel {
    //1. lavel에 표시할 값 변수
    var value: Int = 0 {
        //2. 변수가 바뀔때 마다 감시하고 있다가 label을 변경
        didSet {
            self.text = " \(value)"
        }
    }
    //점수가 올라갈때 10,11,12,13,14,15 이런식으로 처리하기위한 변수
    var endValue: Int = 0
    var timer: Timer? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(font: frame: ")
    }
    //3. 라벨 폰트를 설정하고 백그라운드 컬러는 transparent하게
    init(font: UIFont, frame: CGRect) {
        super.init(frame: frame)
        self.font = font
        self.backgroundColor = UIColor.clear
    }
    
    //timer에서 호출되는 메소드 매 timer event 마다 value을 1증감
    //value 의 didSet에 의해서 변경을 감지하여 라벨을 변경
    func updateValue(timer: Timer) {
        if (endValue < value) {
            value -= 1
        } else {
            value += 1
        }
        
        if (endValue == value) {
            timer.invalidate()
            self.timer = nil
        }
    }
    //주어진 duration 동안 endValue와 value의 차이만큼 나눠서 timer event 발생
    //점수를 1씩 증감하도록 updateValue 호출
    func setValue(newValue: Int, duration: Float) {
        endValue = newValue
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        let delta = abs(endValue - value)
        if (delta != 0) {
            var interval = Double(duration / Float(delta))
            if interval < 0.01 {
                interval = 0.01
            }
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.updateValue(timer:)), userInfo: nil, repeats: true)
        }
    }

}

