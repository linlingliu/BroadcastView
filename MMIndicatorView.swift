//
//  MMIndicatorView.swift
//  CellImageBrowserDemo
//
//  Created by LX on 2018/5/25.
//  Copyright © 2018年 LX. All rights reserved.
//

import UIKit
import CoreGraphics

let kViewItemMargin:CGFloat = 10.0

let kIndicatorColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)

enum MMIndicatorModel {
    case cycle
    case pie
}
class MMIndicatorView: UIView {

    var progress:CGFloat!  {
        willSet(newValue){
            self.setNeedsDisplay()
            if newValue >= 1 {
                self .removeFromSuperview()
            }
        }
    }
   fileprivate var viewModel :MMIndicatorModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = CGFloat(21)
        progress = 0.0
        viewModel = MMIndicatorModel.pie
        self.backgroundColor = kIndicatorColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //swift 的语法
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let xCenter = rect.size.width * 0.5
        let yCenter = rect.size.height * 0.5
        UIColor.white.set()
        if viewModel == MMIndicatorModel.pie {
            let radius = min(rect.size.width * 0.5, rect.size.height * 0.5) - kViewItemMargin
            let w = radius * 2.0 + kViewItemMargin
            let h = w
            let x = (rect.size.width - w) * 0.5
            let y = (rect.size.height - h) * 0.5
            ctx?.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
            ctx?.fillPath()
            kIndicatorColor.set()
            ctx?.move(to: CGPoint(x: xCenter, y: yCenter))
            ctx?.addLine(to: CGPoint(x: xCenter, y: 0))
            print(progress)
            let to =  -CGFloat.pi / 2.0 + progress * CGFloat.pi * 2.0 + 0.001
            ctx?.addArc(center: CGPoint(x: xCenter, y: yCenter), radius: radius, startAngle: -CGFloat.pi / 2.0, endAngle: to, clockwise: true)
            ctx?.closePath()
            ctx?.fillPath()
        }else{
            ctx?.setLineWidth(4.0)
            ctx?.setLineCap(CGLineCap.round)
            let to = progress * CGFloat.pi * 2.0 + 0.001 - (CGFloat.pi * 0.5)
            let radius = min(rect.size.width * 0.5, rect.size.height * 0.5) - kViewItemMargin
            ctx?.addArc(center: CGPoint(x: xCenter, y: yCenter), radius: radius, startAngle: -CGFloat.pi * 0.5, endAngle: to, clockwise: true)
            ctx?.strokePath()
        }
        
        
    }
}
