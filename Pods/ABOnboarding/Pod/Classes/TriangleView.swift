//
//  TriangleView.swift
//  ABOnboarding
//
//  Created by Adam Boyd on 2016-03-01.
//  Copyright © 2016 Under100. All rights reserved.
//
//  From http://stackoverflow.com/questions/30650343/triangle-uiview-swift

import Foundation
import UIKit

public class TriangleView: UIView {
    
    var pointedUp: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        CGContextBeginPath(ctx)
        if self.pointedUp {
            //Triangle points up
            CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect))
            CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
            CGContextAddLineToPoint(ctx, (CGRectGetMaxX(rect)/2.0), CGRectGetMinY(rect))
        } else {
            //Triangle points down
            CGContextMoveToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect))
            CGContextAddLineToPoint(ctx, (CGRectGetMaxX(rect)/2.0), CGRectGetMaxY(rect))
        }
        
        //Finishing up the triangle
        CGContextClosePath(ctx)
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ABOnboardingSettings.OnboardingBackground.getRed(&r, green: &g, blue: &b, alpha: &a)
        CGContextSetRGBFillColor(ctx, r, g, b, a)
        CGContextFillPath(ctx)
    }
}