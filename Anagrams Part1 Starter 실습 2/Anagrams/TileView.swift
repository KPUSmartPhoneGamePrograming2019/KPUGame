//
//  TileView.swift
//  Anagrams
//
//  Created by KIMYOUNG SIK on 2018. 2. 10..
//  Copyright © 2018년 Caroline. All rights reserved.
//
import UIKit
import QuartzCore

protocol TileDragDelegateProtocol {
    func tileView(tileView: TileView, didDragToPoint: CGPoint)
}

//백그라운드 이미지를 가지는 tile을 생성한 후 나중에 letter를 추가함
//1. TileView 클래스가 UIImageView 를 상속하므로 나중에 UILabel과 추가하면 됨
class TileView: UIImageView {
    //손가락으로 tile을 터치할 때 tile의 center에서 x, y offset
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0
    
    var tempTransform: CGAffineTransform = CGAffineTransform.identity
    var dragDelegate: TileDragDelegateProtocol?

    //2. letter 변수
    var letter: Character
    //3. match true/false 변수
    var isMatched: Bool = false
    //4. 이 코드는 호출되면 안됨
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(letter:, sideLength:")
    }
    //5. 주어진 letter 에 대한 새로운 타일 생성
    init(letter: Character, sideLength: CGFloat) {
        self.letter = letter
        //tile.png 를 백그라운드 이미지로 로딩
        let image = UIImage(named: "tile")!
        
        super.init(image: image)
        //anagram이 길수 있으니까 스크린 크기에 맞도록 scale
        //TileView의 frame 을 자동으로 resize
        let scale = sideLength / image.size.width
        self.frame = CGRect(x: 0, y: 0, width: image.size.width * scale, height: image.size.height * scale)
        
        // init() 메소드 끝에 글자 label을 타일에 추가
        let letterLabel = UILabel(frame: self.bounds)
        letterLabel.textAlignment = NSTextAlignment.center
        letterLabel.textColor = UIColor.white
        letterLabel.backgroundColor = UIColor.clear
        letterLabel.text = String(letter).uppercased()
        letterLabel.font = UIFont(name: "Verdana-Bold", size: 78 * scale)
        self.addSubview(letterLabel)
        //iOS가 tileView의 touch event를 전달하도록 해준다.
        self.isUserInteractionEnabled = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        self.layer.shadowRadius = 15.0
        self.layer.masksToBounds = false
        let path = UIBezierPath(rect: self.bounds)
        self.layer.shadowPath = path.cgPath
    }
    //게임 보드에서 anagram 글자를 slightly random하게 회전하면 좀더 자연스럽게 보인다.
    func randomize() {
        //-0.2~0.3 라디안 랜덤 생성
        let rotation = CGFloat(randomNumber(minX: 0, maxX: 50)) / 100 - 0.2
        //회전
        self.transform = CGAffineTransform(rotationAngle: rotation)
        //upwards 방향 -10~0 랜덤 생성
        let yOffset = CGFloat(randomNumber(minX: 0, maxX: 10) - 10)
        self.center = CGPoint(x: self.center.x , y: self.center.y + yOffset)
    }
    
    //title dragging 메소드들
    //1. 터치가 감지되면 tile안의 터치 위치를 얻어서 xOffset/yOffset 계산
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.superview)
            xOffset = touchPoint.x - self.center.x
            yOffset = touchPoint.y - self.center.y
        }
        self.layer.shadowOpacity = 0.8
        tempTransform = self.transform
        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.superview?.bringSubview(toFront: self)
    }
    //2. 터치를 움직이면 tile 위치를 움직인다. xOffset/yOffset을 반영해서 center 를 옮김
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPoint = touch.location(in: self.superview)
            self.center = CGPoint(x: touchPoint.x - xOffset, y: touchPoint.y - yOffset)
        }
    }
    //3. 손가락을 떼면 마직막으로 touchesMoved() 호출한다.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesMoved(touches, with: event)
        //drageDelegate의 tileView 메소드를 호출해서 tile(self)과 self.center 를 전달
        self.dragDelegate?.tileView(tileView: self, didDragToPoint: self.center)
        self.layer.shadowOpacity = 0.0
       self.transform = tempTransform
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = tempTransform
        self.layer.shadowOpacity = 0.0
    }
}
