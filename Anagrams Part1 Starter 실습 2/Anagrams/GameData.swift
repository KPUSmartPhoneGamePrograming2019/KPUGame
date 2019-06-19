//
//  GameData.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 12..
//  Copyright © 2018년 Caroline. All rights reserved.
//

import Foundation
//tile을 target 위치에 올바르게 가져가면 점수를 얻고
//tile을 다른 target 위치에 가져가면 점수를 잃는다.
class GameData {
    //게임 점수 저장 변수
    var points: Int = 0 {
        didSet {
            //점수를 양수로 저장
            points = max(points, 0)
        }
    }
}

