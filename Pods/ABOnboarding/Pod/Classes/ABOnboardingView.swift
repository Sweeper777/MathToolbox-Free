//
//  OnboardingView.swift
//  ABOnboarding
//
//  Created by Adam Boyd on 2016-02-29.
//  Copyright © 2016 Under100. All rights reserved.
//

import Foundation
import UIKit

public class ABOnboardingView: UIView {
    
    var textLabel = UILabel()
    var buttonContainer = UIView()
    var nextButton = FilledRoundedButton()
    var laterButton = UIButton()
    var triangleView = TriangleView()
    var imageView: UIImageView?
    
    //Constraints for animating
    var leftConstraint: NSLayoutConstraint?
    var rightConstraint: NSLayoutConstraint?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ABOnboardingSettings.OnboardingBackground
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setUpWith(item: ABOnboardingItem, firstItem: Bool, lastItem: Bool) {
        switch item.message {
        case .Regular(let string):              self.textLabel.text = string
        case .Attributed(let attributedString): self.textLabel.attributedText = attributedString
        }
        self.imageView = UIImageView(image: item.image)
        
        switch item.placement {
        case .Above(_), .PointingDownAt(_):
            self.addTriangleView(false)
        case .Below(_), .PointingUpAt(_):
            self.addTriangleView(true)
        default:
            break //No Triangle
        }
        
        self.setUpLabelAndButtonsAndImage(firstItem, lastItem: lastItem, textAlign: item.textAlign)
    }
    
    /**
     Adds all the labels and buttons to self with the correct layout constraints
     */
    public func setUpLabelAndButtonsAndImage(firstItem: Bool, lastItem: Bool, textAlign: NSTextAlignment) {
        // Check if the text should be below the image or at the top of the container view
        var topView: UIView = self
        var topViewAttribute = NSLayoutAttribute.Top
        
        //Setting up the image view (if it was provided)
        if let imageView = self.imageView {
            // Mark that an image view was supplied so the text should align below it
            topView = imageView
            topViewAttribute = NSLayoutAttribute.Bottom
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(imageView)
            
            self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 16))
            self.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        }
        
        //Setting up the text label
        self.textLabel.textColor = ABOnboardingSettings.OnboardingText
        self.textLabel.font = ABOnboardingSettings.Font
        self.textLabel.numberOfLines = 0
        self.textLabel.textAlignment = textAlign
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.textLabel)
        
        //0px from top, left, right
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Top, relatedBy: .Equal, toItem: topView, attribute: topViewAttribute, multiplier: 1, constant: 16))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 8))
        self.addConstraint(NSLayoutConstraint(item: self.textLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: -8))
        
        
        //Setting up the button container
        self.buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.buttonContainer)
        
        //16px from label, 8px from bottom
        self.addConstraint(NSLayoutConstraint(item: self.buttonContainer, attribute: .Top, relatedBy: .Equal, toItem: self.textLabel, attribute: .Bottom, multiplier: 1, constant: 16))
        self.addConstraint(NSLayoutConstraint(item: self.buttonContainer, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.buttonContainer, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -16))
        self.addConstraint(NSLayoutConstraint(item: self.buttonContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40))
        
        
        //Setting up the next button
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.setTitle((lastItem ? "Done" : "Next"), forState: .Normal)
        self.nextButton.titleLabel?.font = ABOnboardingSettings.Font
        self.buttonContainer.addSubview(self.nextButton)
        
        //0px right from center x, 0px from top, right, bottom
        self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.nextButton, attribute: .Top, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Top, multiplier: 1, constant: 0))
        self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.nextButton, attribute: .Right, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Right, multiplier: 1, constant: 0))
        self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.nextButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Bottom, multiplier: 1, constant: 0))
        self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.nextButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 137))
        if lastItem {
            self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.nextButton, attribute: .Left, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Left, multiplier: 1, constant: 0))
        } else {
            self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.nextButton, attribute: .Left, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .CenterX, multiplier: 1, constant: 10))
        }
        
        //Setting up the later button
        self.laterButton.setTitle(firstItem ? "Maybe Later" : "Skip", forState: .Normal)
        self.laterButton.setTitleColor(ABOnboardingSettings.OnboardingLaterText, forState: .Normal)
        self.laterButton.titleLabel?.font = ABOnboardingSettings.Font
        self.laterButton.translatesAutoresizingMaskIntoConstraints = false
        if !lastItem {
            self.buttonContainer.addSubview(self.laterButton)
            
            //0px right from center x, 0px from top, left, bottom
            self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.laterButton, attribute: .Top, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Top, multiplier: 1, constant: 0))
            self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.laterButton, attribute: .Left, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Left, multiplier: 1, constant: 0))
            self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.laterButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.buttonContainer, attribute: .Bottom, multiplier: 1, constant: 0))
            self.buttonContainer.addConstraint(NSLayoutConstraint(item: self.laterButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
        }
    }
    
    public func addTriangleView(aboveView: Bool) {
        self.triangleView.pointedUp = aboveView
        self.triangleView.backgroundColor = UIColor.clearColor()
        self.triangleView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.triangleView)
        
        //15px tall, wide, x position determined by item it is pointing to, happens in ShowsOnboardingItem
        self.addConstraint(NSLayoutConstraint(item: self.triangleView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 15))
        self.addConstraint(NSLayoutConstraint(item: self.triangleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20))
        
        if aboveView {
            //If the triangle goes above
            self.addConstraint(NSLayoutConstraint(item: self.triangleView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        } else {
            //If the triangle goes below
            self.addConstraint(NSLayoutConstraint(item: self.triangleView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
        }
    }
    
}