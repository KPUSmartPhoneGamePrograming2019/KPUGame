//
//  PushButtonView.swift
//  Flo
//
//  Created by KPUGAME on 2019. 6. 10..
//  Copyright © 2019년 KPUGAME. All rights reserved.
//

import UIKit
@IBDesignable   // 실행하지 않아도 함수가 호출되도록 하는듯.
class PushButtonView: UIButton {

    //@IBInspectable 은 변수를 storyboard IB에서 변경할 수 있도록 해줌
    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isAddButton: Bool = true
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        //UIColor.blue.setFill()
        fillColor.setFill()
        path.fill()
        // 수평 스트로크를 위해서 width height 상수 정의
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        // path 생성
        let plusPath = UIBezierPath()
        // path라인 넓이를 height로 설정
        plusPath.lineWidth = plusHeight
        
        // path의 스트로크 시작점으로 이동
        plusPath.move(to: CGPoint(x:bounds.width/2 - plusWidth/2 + 0.5, y:bounds.height/2 + 0.5)) // 안티 앨리어싱을 없애기 위해
        // path의 라인을 ㄱ연결
        plusPath.addLine(to: CGPoint(x:bounds.width/2 + plusWidth/2 + 0.5, y:bounds.height/2 + 0.5)) // 안티 앨리어싱을 없애기 위해
        
        if isAddButton {
        plusPath.move(to: CGPoint(x:bounds.width/2 + 0.5, y:bounds.height/2 - plusWidth/2 + 0.5)) // 안티 앨리어싱을 없애기 위해
        // path의 라인을 ㄱ연결
        plusPath.addLine(to: CGPoint(x:bounds.width/2 + 0.5, y:bounds.height/2 + plusWidth/2 + 0.5)) // 안티 앨리어싱을 없애기 위해
        }
        // 스트로크 색 결정
        UIColor.white.setStroke()
        
        // 스트로크 드로잉
        plusPath.stroke()
    }
 

}
