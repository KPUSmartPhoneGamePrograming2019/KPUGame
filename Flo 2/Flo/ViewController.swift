//
//  ViewController.swift
//  Flo
//
//  Created by KPUGAME on 2019. 6. 10..
//  Copyright © 2019년 KPUGAME. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // label outlets
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    // Counter outlets
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
    // 플러스 버튼을 누르면 counter를 증가하고 마이너스 버튼을 누르면 counter를 감소한다.
    // counter값을 counterLabel라벨에 펴시
    @IBAction func pushButtonPressed(_ button: PushButtonView) {
        if button.isAddButton {
            counterView.counter += 1
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // counterLabel의 초기값 설정
        counterLabel.text = String(counterView.counter)
    }

    func setupGraphDisplay() {
        let maxDayIndex = stackView.arrangedSubviews.count - 1
        //  1- replace last day with today's actual data
        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
        // 2 - indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        maxLabel.text = "\(graphView.graphPoints.max()!)"
        let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        // 4. - setup data formatter and calendar
        let today = Date()
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        
        // 5. set up the day name labels with correct days
        for i in 0...maxDayIndex {
            if let date = calendar.date(byAdding: .day, value: -i, to: today),
                let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
                label.text = formatter.string(from: date)
            }
        }
        
    }

}

