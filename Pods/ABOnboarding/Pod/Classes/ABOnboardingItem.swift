//
//  OnboardingItem.swift
//  ABOnboarding
//
//  Created by Adam Boyd on 2016-02-29.
//  Copyright © 2016 Under100. All rights reserved.
//

import Foundation
import UIKit

public enum RelativePlacement {
    case Above(UIView), Below(UIView), RelativeToTop(CGFloat), RelativeToBottom(CGFloat), PointingUpAt(CGRect), PointingDownAt(CGRect)
}

public enum StringType {
    case Regular(String),
         Attributed(NSAttributedString)
    
    init(string: String) {
        self = .Regular(string)
    }
    
    init(attributedString: NSAttributedString) {
        self = .Attributed(attributedString)
    }
}

@objc public class ABOnboardingItem: NSObject {
    var message: StringType
    var placement: RelativePlacement
    var onboardingView: ABOnboardingView! {
        didSet {
            if let leftTitle = self.leftButtonTitle {
                self.onboardingView.laterButton.setTitle(leftTitle, forState: .Normal)
            }
            
            if let rightTitle = self.rightButtonTitle {
                self.onboardingView.nextButton.setTitle(rightTitle, forState: .Normal)
            }
        }
    }
    var blurredBackground: Bool
    var nextItemAutomaticallyShows: Bool
    var leftButtonTitle: String?
    var rightButtonTitle: String?
    var image: UIImage?
    var textAlign: NSTextAlignment
    
    //Regular strings
    public init(message: String, placement: RelativePlacement, blurredBackground: Bool, nextItemAutomaticallyShows: Bool = true, leftButtonTitle: String? = nil, rightButtonTitle: String? = nil, image: UIImage? = nil, textAlign: NSTextAlignment = .Left) {
        self.message = StringType(string: message)
        self.placement = placement
        self.blurredBackground = blurredBackground
        self.nextItemAutomaticallyShows = nextItemAutomaticallyShows
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.image = image
        self.textAlign = textAlign
    }
    
    //Attributed strings
    public init(attributedString: NSAttributedString, placement: RelativePlacement, blurredBackground: Bool, nextItemAutomaticallyShows: Bool = true, leftButtonTitle: String? = nil, rightButtonTitle: String? = nil, image: UIImage? = nil, textAlign: NSTextAlignment = .Left) {
        self.message = StringType(attributedString: attributedString)
        self.placement = placement
        self.blurredBackground = blurredBackground
        self.nextItemAutomaticallyShows = nextItemAutomaticallyShows
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.image = image
        self.textAlign = textAlign
    }
}