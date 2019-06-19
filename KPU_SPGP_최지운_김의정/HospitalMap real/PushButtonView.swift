//
//  PushButtonView.swift
//  Flo
//
//  Created by 최지 on 10/06/2019.
//  Copyright © 2019 최지. All rights reserved.
//

import UIKit
@IBDesignable
class PushButtonView: UIButton {

    @IBInspectable var fillColor: UIColor = UIColor.green
    @IBInspectable var isAddButton: Bool = true
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        //UIColor.blue.setFill()
        fillColor.setFill()
        
        path.fill()
        
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        let plusPath = UIBezierPath()
        
        plusPath.lineWidth = plusHeight
        
        plusPath.move(to: CGPoint(
            x:bounds.width/2 - plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        if isAddButton{
        plusPath.move(to: CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 - plusWidth/2 + 0.5))
        
        plusPath.addLine(to: CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 + plusWidth/2 + 0.5))
        }
        
        UIColor.white.setStroke()
        
        plusPath.stroke()
        
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
