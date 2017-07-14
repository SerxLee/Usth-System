//
//  USWaveView.swift
//  Usth System
//
//  Created by Serx on 2017/7/14.
//  Copyright © 2017年 Serx. All rights reserved.
//

import UIKit

class USWaveView: UIView {

    // 波浪曲线：y = h * sin(a * x + b); h: 波浪高度， a: 波浪宽度系数， b： 波的移动
    
    // 波浪高度h
    var waveHeight: CGFloat = 5
    // 波浪宽度系数a
    var waveRate: CGFloat = 0.01
    // 波浪移动速度
    var waveSpeed: CGFloat = 0.05
    // 真实波浪颜色
    var realWaveColor: UIColor = UIColor.white
    // 阴影波浪颜色
    var maskWaveColor: UIColor = UIColor.noodleBlue()
    
    var closure: ((_ centerY: CGFloat)->())?
    
    private var displayLink: CADisplayLink?
    
    private var realWaveLayer: CAShapeLayer?
    private var maskWaveLayer: CAShapeLayer?
    
    private var offset: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWaveParame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWaveParame()
    }
    
    private func initWaveParame() {
        
        // 真实波浪配置
        realWaveLayer = CAShapeLayer()
        var frame = bounds
        realWaveLayer?.frame.origin.y = frame.size.height - waveHeight
        frame.size.height = waveHeight
        realWaveLayer?.frame = frame
        
        // 阴影波浪配置
        maskWaveLayer = CAShapeLayer()
        maskWaveLayer?.frame.origin.y = frame.size.height - waveHeight
        frame.size.height = waveHeight
        maskWaveLayer?.frame = frame
        
        layer.addSublayer(maskWaveLayer!)
        layer.addSublayer(realWaveLayer!)
    }
    
    func startWave() {
        displayLink = CADisplayLink(target: self, selector: #selector(self.wave))
        displayLink!.add(to: RunLoop.main, forMode: .commonModes);
    }
    
    func endWave() {
        displayLink!.invalidate()
        displayLink = nil
    }
    
    @objc func wave() {
        // 波浪移动的关键：按照指定的速度偏移
        offset += waveSpeed
        
        // 从左下角开始
        let realPath = UIBezierPath()
        realPath.move(to: CGPoint(x: 0, y: frame.size.height))
        
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint(x: 0, y: frame.size.height))
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        while x <= bounds.size.width {
            // 波浪曲线
            y = waveHeight * sin(x * waveRate + offset)
            
            realPath.addLine(to: CGPoint(x: x, y: y))
            maskPath.addLine(to: CGPoint(x: x, y: -y))
            
            // 增量越小，曲线越平滑
            x += 0.1
        }
        
        let midX = bounds.size.width * 0.5
        let midY = waveHeight * sin(midX * waveRate + offset)
        
        if let closureBack = closure {
            closureBack(midY)
        }
        // 回到右下角
        realPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        maskPath.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
        
        // 闭合曲线
        maskPath.close()
        
        // 把封闭图形的路径赋值给CAShapeLayer
        maskWaveLayer?.path = maskPath.cgPath
        maskWaveLayer?.fillColor = maskWaveColor.cgColor
        
        realPath.close()
        realWaveLayer?.path = realPath.cgPath
        realWaveLayer?.fillColor = realWaveColor.cgColor
    }


}
