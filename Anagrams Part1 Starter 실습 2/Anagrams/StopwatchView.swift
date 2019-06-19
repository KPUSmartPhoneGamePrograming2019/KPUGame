//
//  StopwatchView.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 10..
//  Copyright © 2018년 Caroline. All rights reserved.
//
import UIKit
//UILabel을 상속함
class StopWatchView: UILabel {
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(fram: )")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //라벨의 백그라운드를 transparent하게
        self.backgroundColor = UIColor.clear
        self.font = FontHUDBig
    }
    //time fomatting하는 helper 메소드, 몇초 남았는지 알려줌
    func setSeconds(_ seconds: Int) {
        self.text = String(format: " %02i : %02i", seconds / 60, seconds % 60)
    }
}

