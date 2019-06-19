//
//  CounterView.swift
//  Flo
//
//  Created by KPUGAME on 2019. 6. 10..
//  Copyright © 2019년 KPUGAME. All rights reserved.
//

import UIKit
@IBDesignable
class CounterView: UIView {

    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    @IBInspectable var counter: Int = 5 {
        didSet {
            if counter <= Constants.numberOfGlasses {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        // 콤파스를 이용해서 반지름만큼 조정한 후 두꺼운 펜으로 돌리면서 아크를 그림
        // 1. 아크 센터 설정 = 뷰의 중앙
        let center = CGPoint(x:bounds.width/2, y:bounds.height/2)
        
        // 2. 반지름 설정은 바운드의 max
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // 3. 아크의 시작과 끝
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        
        // 4. 패스 설정
        let path = UIBezierPath(arcCenter: center, radius: radius/2 - Constants.arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        // 5. 스트로크
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        // 아웃라인 그리기
        // 1. - 두각도 사이의 차이 270도 계산
        let angleDifference: CGFloat = 2.0 * .pi - startAngle + endAngle
        // 물한잔에 해당하는 각도 게산 = 270 / 8
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        // counter변수를 이용해 실제 그릴 각도 계산
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        // 2 - 바깥쪽 아크 그리기, 반지름이 크다.
        let outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - 2.5, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)
        // 3 - 안쪽 아크 그리기, 반지름이 작다
        outlinePath.addArc(withCenter: center, radius: bounds.width/2 - Constants.arcWidth + 2.5, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
        // 4 - 크로우즈패스로 설정하고 스트로크
        outlinePath.close()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = 5.0
        outlinePath.stroke()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
