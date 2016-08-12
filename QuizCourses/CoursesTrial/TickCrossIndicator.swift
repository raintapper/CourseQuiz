//
//  TickCrossIndicator.swift
//  CoursesTrial
//
//  Created by Barry Chew on 10/8/16.
//  Copyright © 2016 Ahanya. All rights reserved.
//

import UIKit

@IBDesignable class TickCrossIndicator: UIView {
    
    @IBInspectable var isCorrect: Bool = true
    
    
    override func drawRect(rect: CGRect) {
        

        let lineWidth: CGFloat = 4.0
        
        
        if isCorrect {
            
            let tickPath = UIBezierPath()
            tickPath.lineWidth = lineWidth
            
            tickPath.moveToPoint(CGPoint(x: 0, y: bounds.height * 4/7))
            tickPath.addLineToPoint(CGPoint(x: bounds.width * 1/7, y: bounds.height))
            tickPath.addLineToPoint(CGPoint(x: bounds.width, y: bounds.height * 1/7))
            UIColor.greenColor().setStroke()
            tickPath.stroke()
            //tickPath.closePath()
            //tickPath.addClip()
            
        } else {
            
            
            let crossPath = UIBezierPath()
            crossPath.lineWidth = lineWidth
            
            crossPath.moveToPoint(CGPoint(x:0, y:bounds.height * 1/7))
            crossPath.addLineToPoint(CGPoint(x: bounds.width, y: bounds.height))
            crossPath.moveToPoint(CGPoint(x: 0, y: bounds.height))
            crossPath.addLineToPoint(CGPoint(x: bounds.width, y: bounds.height * 1/7))
            
            UIColor.redColor().setStroke()
            crossPath.stroke()
        }
        
        
        
    }
    
    
    
}
