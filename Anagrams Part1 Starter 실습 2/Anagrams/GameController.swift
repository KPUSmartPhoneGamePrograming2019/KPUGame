//
//  GameController.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 10..
//  Copyright © 2018년 Caroline. All rights reserved.
//
// 타일을 움직일 때 GameController 에게 notificaiton 을 주려면
// GameController 가 tile들의 delegate 가 되어야 한다.

import UIKit

class GameController: TileDragDelegateProtocol {
    var gameView: UIView!   //game elements를 표시하는 view
    var level: Level!       //현재 레벨의 anagram과 설정을 갖는 Level 객체
    var audioController: AudioController
    var onAnagramSolved: (() -> ())!
    
    func clearBoard(){
        tiles.removeAll(keepingCapacity: false)
        tiles.removeAll(keepingCapacity: false)
        for view in gameView.subviews{
            view.removeFromSuperview()
        }
    }
    //TileView 객체 배열, 스크린 하단에 tile들을 표시,
    //tile들은 초기 anagram을 가짐
    var tiles: [TileView]
    var targets: [TargetView]
    var hud: HUDView! {
        didSet{
            hud.hintButton.addTarget(self, action: #selector(self.actionHint), for: .touchUpInside)
            hud.hintButton.isEnabled = false
        }
    }
    //stopWatch 변수들
    private var seconsLeft: Int = 0
    private var timer: Timer? = nil
    
    var data = GameData()
    init() {
        //타일 빈 배열 생성
        tiles = []
        targets = []
        audioController = AudioController()
        audioController.preloadAudioEffects(audioFileNames: AudioEffectFiles)
    }
    //현재 레벨 anagram을 스크린에 표시하는 메소드
    //랜덤 anagram을 가져와서 letter tile 과 target 을 다룬다.
    func dealRandomAnagram() {
        //1. Level 객체 level이 제대로 로딩되는지 첵크한다.
        assert(level.anagrams.count > 0, "No level loaded")
        //timer 시작
        self.startWatch()

        //2. anagram 램덤 인덱스 생성, randomNumber()함수는  Config.swift에 있음
        let randomIndex = randomNumber(minX: 0, maxX: UInt32(level.anagrams.count - 1))
        let anagramPair = level.anagrams[randomIndex]
        //3. 2개 anagram 어절을 가져옴
        let anagram1 = anagramPair[0] as! String
        let anagram2 = anagramPair[1] as! String
        //4. 2개 어절의 길이를 가져옴, 2개 어절의 길이가 다를 수 있음.
        let anagram1Length = anagram1.characters.count
        let anagram2Length = anagram2.characters.count
        //5. 콘솔에 2개 어절을 써본다.
        print("phrase1[\(anagram1Length)]: \(anagram1)")
        print("phrase2[\(anagram2Length)]: \(anagram2)")
        //스크린의 90%를 사용하고 anagram 글자 길이에 따라서 tileSide 계산, TileMargin도 고려함
        let tileSide = ceil(ScreenWidth * 0.9 / CGFloat(max(anagram1Length, anagram2Length))) - TileMargin
        //첫번째 타일 위치 계산
        var xOffset = (ScreenWidth - CGFloat(max(anagram1Length, anagram2Length)) * (tileSide + TileMargin)) / 2.0 + TileMargin / 2.0
        //타일의 위치는 타일의 중심으로 계산
        xOffset += tileSide / 2.0
        
        //targetView는 tileView와 유사하나 anagram2에서 가져옴
        for (index, letter) in anagram2.characters.enumerated() {
            if letter != " " {
                let target = TargetView(letter: letter, sideLength: tileSide)
                target.center = CGPoint(x: xOffset + CGFloat(index) * (tileSide + TileMargin), y: ScreenHeight / 4)
                
                gameView.addSubview(target)
                targets.append(target)
            }
        }

        //타일을 생성, enumerated()는 index/value tuple 생성
        for (index, letter) in anagram1.characters.enumerated() {
            //글자가 스페이스가 아니면 타일 생성
            if letter != " " {
                let tile = TileView(letter: letter, sideLength: tileSide)
                //글자 index에의해서 x 위치 결정, y는 스크린 3/4 위치
                tile.center = CGPoint(x: xOffset + CGFloat(index) * (tileSide + TileMargin), y: ScreenHeight / 4 * 3)
                //타일 slightly rotate
                tile.randomize() // rotate it
                tile.dragDelegate = self
                //tile을 gameView에 추가
                gameView.addSubview(tile)
                //타일을 배열에 추가
                tiles.append(tile)
            }
        }
        hud.hintButton.isEnabled = true
    }
    //tile 이 target 에서 match될 때 호출되는 메소드
    func placeTile(tileView: TileView, targetView: TargetView) {
        //1. target과 tile모두 isMatched 를 true 로 세팅, 나중에 성공 검사에 활용
        targetView.isMatched = true
        tileView.isMatched = true
        //2. 성공한 tile 은 이제 못 움직임
        tileView.isUserInteractionEnabled = false
        //3. 0.5초동안 .curveEaseOut 으로 움직이는 animation (처음엔 많이 뒤에 조금 변함)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIViewAnimationOptions.curveEaseOut,
            //4. tile의 center를 target center로 변경
            animations: {
                tileView.center = targetView.center
            },
            //5. animation 끝에 targetView를 가린다.
            completion: {(value: Bool) in
                tileView.transform = CGAffineTransform(rotationAngle: 0)
                targetView.isHidden = true
            }
        )
        let explore = ExplodeView(frame: CGRect(x: tileView.center.x, y: tileView.center.y, width: 10, height: 10))
        tileView.superview?.addSubview(explore)
        tileView.superview?.sendSubview(toBack: explore)
    }
    //게임 종료 검사 메소드
    func checkForSuccess() {
        for tgv in targets {
            if !tgv.isMatched {
                return
            }
        }
        self.stopWatch()
        audioController.playerEffect(name: SoundWin)
        
        let firstTarget = targets[0]
        let starX: CGFloat = 0
        let endX: CGFloat = ScreenWidth + 300
        let starY = firstTarget.center.y
        
        let stars = StardustView(frame: CGRect(x: starX, y: starY, width: 10, height: 10))
        gameView.addSubview(stars)
        gameView.sendSubview(toBack: stars)
        
        UIView.animate(withDuration: 3.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            stars.center = CGPoint(x: endX, y: starY)
        }, completion: {(value: Bool) in stars.removeFromSuperview(); self.clearBoard(); self.onAnagramSolved()})
        
        hud.hintButton.isEnabled = false
        print("Game Over!")
    }
    
    
    
    //타일을 drag할 때 호출되는 delegate 메소드
    func tileView(tileView: TileView, didDragToPoint point: CGPoint) {
        var targetView: TargetView?
        //targets배열에서 하나씩 view를 꺼내서 point를 포함하는지 검사하고 target 이 맞는지 검사
        for target in targets {
            if target.frame.contains(point) && !target.isMatched {
                targetView = target
                break
            }
        }
        //1. target을 찾았는지 검사
        if let tgv = targetView {
            //2. target letter와 tileView letter가 같은지 검사
            if tgv.letter == tileView.letter {
                //tile을 올바른 target에 가져옴
                self.placeTile(tileView: tileView, targetView: tgv)
                //점수 얻기
                data.points += level.pointsPerTile
                //hud gamePoints 라벨 변경
                //hud.gamePoints.value = data.points
                //점수를 10,11,12,13,14,15 로 애니메이션으로 통해서 변경
                hud.gamePoints.setValue(newValue: data.points, duration: 0.5)
                audioController.playerEffect(name: SoundDing)

                self.checkForSuccess()
            } else {
                //4. target이 match되지 않으면 player에게 알려야 한다.
                //1. tile rotation angle을 랜덤하게 결정
                tileView.randomize()
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.0,
                    options: UIViewAnimationOptions.curveEaseOut,
                    //2. tile position을 랜덤하게 결정
                    animations: {
                        tileView.center = CGPoint(
                            x: tileView.center.x + CGFloat(randomNumber(minX: 0, maxX: 40) - 20),
                            y: tileView.center.y + CGFloat(randomNumber(minX: 20, maxX: 30)))
                    },
                    completion: nil
                )
                //점수 잃기
                data.points -= level.pointsPerTile / 2
                //hud gamePoints 라벨 변경
                //hud.gamePoints.value = data.points
                //점수를 10,11,12,13,14,15 로 애니메이션으로 통해서 변경
                hud.gamePoints.setValue(newValue: data.points, duration: 0.5)
                audioController.playerEffect(name: SoundWrong)
            }
        }
    }
    //첫번째 timer 메소드
    func startWatch() {
        //HUD timer 관련 변수 초기화
        seconsLeft = level.timeToSolve
        hud.stopWatch.setSeconds(seconsLeft)
        //new timer 스케쥴링
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tick(_:)), userInfo: nil, repeats: true)
    }
    //두번째 timer 메소드
    //timer가 매초마다 호출하는 메소드
    //@objc 표시는 Timer가 Objective-C class 라서 Objective-C 에서 보이게 하려고 함
    @objc func tick(_ timer: Timer) {
        seconsLeft -= 1
        hud.stopWatch.setSeconds(seconsLeft)
        if seconsLeft == 0 {
            self.stopWatch()
        }
    }
    //세번째 timer 메소드
    //player가 puzzle을 완성하거나 time's up되면 timer를 stop함
    func stopWatch() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func actionHint(){
        hud.hintButton.isEnabled = false
        data.points -= level.pointsPerTile / 2
        hud.gamePoints.setValue(newValue: data.points, duration: 1.5)
        
        var foundTarget: TargetView? = nil
        for target in targets{
            if !target.isMatched{
                foundTarget = target
                break
            }
        }
        var foundTile: TileView? = nil
        for tile in tiles{
            if !tile.isMatched && tile.letter == foundTarget?.letter{
                foundTile = tile
                break
            }
        }
        if let target = foundTarget, let tile = foundTile{
            gameView.bringSubview(toFront: tile)
            UIView.animate(withDuration: 1.5,
                           delay: 0.0,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            tile.center = target.center
                            
            },
                           completion: {
                            (value:Bool) in self.placeTile(tileView: tile, targetView: target)
                            self.hud.hintButton.isEnabled = true; self.checkForSuccess()
                            
            })
        }
    }

}
