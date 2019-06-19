//
//  Level.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 10..
//  Copyright © 2018년 Caroline. All rights reserved.
//

import Foundation

//level*.plist 파일의 property들을 읽기위한 구조체
struct Level {
    let pointsPerTile: Int
    let timeToSolve: Int
    let anagrams: [NSArray]
    
    init(level: Int) {
        // 1 레벨에 맞는 .plist 파일을 찾는다.
        let fileName = "level\(level)"
        let fileExts = "plist"
        let levelPath = Bundle.main.path(forResource: fileName, ofType: fileExts)
        
        // 2 .plist 파일 로딩
        let levelDictionary: NSDictionary? = NSDictionary(contentsOfFile: levelPath!)
        
        // 3 파일이 있는지 검증
        assert(levelDictionary != nil, "Level configuration file not found !")
        
        // 4 .plist dictionary에서 데이터 복사
        self.pointsPerTile = levelDictionary!["pointsPerTile"] as! Int
        self.timeToSolve = levelDictionary!["timeToSolve"] as! Int
        self.anagrams = levelDictionary!["anagrams"] as! [NSArray]
    }
}

