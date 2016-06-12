//
//  RoundedFilledButton.swift
//  ABOnboarding
//
//  Created by Adam Boyd on 2016-04-05.
//
//

import Foundation
import UIKit

class FilledRoundedButton: UIButton {
    override var highlighted: Bool {
        didSet {
            self.tweakState(self.highlighted)
        }
    }
    
    override var selected: Bool {
        didSet {
            self.tweakState(self.selected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.modifyLook()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.modifyLook()
    }
    
    func modifyLook() {
        self.layer.cornerRadius = 20
        self.layer.borderColor = ABOnboardingSettings.ButtonBorderNormal.CGColor
        self.layer.borderWidth = 1
        self.setTitleColor(ABOnboardingSettings.ButtonTextNormal, forState: .Normal)
        self.backgroundColor = ABOnboardingSettings.ButtonBackgroundNormal
    }
    
    func tweakState(highlighted: Bool) {
        if highlighted {
            self.layer.borderColor = ABOnboardingSettings.ButtonBorderHighlighted.CGColor
            
            //Animate to being highlighted
            UIView.animateWithDuration(0.20) { () -> Void in
                self.titleLabel?.textColor = ABOnboardingSettings.ButtonTextHighlighted
                self.backgroundColor = ABOnboardingSettings.ButtonBackgroundHighlighted
            }
        } else {
            self.layer.borderColor = ABOnboardingSettings.ButtonBorderNormal.CGColor
            
            //Animate away from being highlighted
            UIView.animateWithDuration(0.20) { () -> Void in
                self.titleLabel?.textColor = ABOnboardingSettings.ButtonTextNormal
                self.backgroundColor = ABOnboardingSettings.ButtonBackgroundNormal
            }
        }
    }
}