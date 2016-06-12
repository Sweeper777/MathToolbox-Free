ABOnboarding
==============
[![CocoaPods](https://img.shields.io/cocoapods/v/HidingNavigationBar.svg)](https://github.com/MrAdamBoyd/ABOnboarding)

An easy to use library built for the first time user experience of your iOS app. Written in Swift.
- [Screenshots](#screenshots)
- [Usage](#usage)
- [Customization](#customization)
- [Installation](#installation)
- [Example](#example)
- [Credits](#credits)

#Screenshots
![Screenshot](https://raw.githubusercontent.com/MrAdamBoyd/ABOnboarding/master/screenshots/screenshot1.png)
![Screenshot](https://raw.githubusercontent.com/MrAdamBoyd/ABOnboarding/master/screenshots/screenshot2.png)

#Usage
###1
Make your view controller conform to `ShowsABOnboardingItem`

###2
Add the following variables to your view controller:
```swift 
    var onboardingToShow: [ABOnboardingItem] = []
    var onboardingIndex: Int = 0
    var currentBlurViews: [UIView] = []
    var onboardingSection: Int = 0
```
###3
Add the following methods to your view controller. Due to the limitations of selectors in Swift, you will have to add two action forwarders, seen below:
```swift 
    func userSkippedOnboarding() {
        //Save the status
    }
    func userCompletedOnboarding() {
        //Save the status
    }
    func shouldShowOnboardingOnThisVC() -> Bool {
        //Your logic for whether or not to show onboarding
    }

    //Action forwarders
    func skipOnboardingForwarder() {
        self.skipOnboarding()
    }
    func showNextOnboardingItemForwarder() {
        self.showNextOnboardingItem()
    }
```
###4
Set the onboarding items that you want to show. There are two different inits for `AbOnboardingItem`, one with a regular `String` and one with an `NSAttributedString`:
```swift 
init(message: String, placement: RelativePlacement, blurredBackground: Bool, nextItemAutomaticallyShows: Bool = true, leftButtonTitle: String? = nil, rightButtonTitle: String? = nil, image: UIImage? = nil, textAlign: NSTextAlignment = .Left)
init(attributedString: NSAttributedString, placement: RelativePlacement, blurredBackground: Bool, nextItemAutomaticallyShows: Bool = true, leftButtonTitle: String? = nil, rightButtonTitle: String? = nil, image: UIImage? = nil, textAlign: NSTextAlignment = .Left)
```
`message`: `String` OR 'attributedString`: `NSAttributedString` - The main text of the onboarding view.

`placement`: `RelativePlacement` - Where the onboarding item will show on screen. Here is the RelativePlacement enum
```swift 
public enum RelativePlacement {
    case Above(UIView),
    Below(UIView),
    RelativeToTop(CGFloat), #No arrow
    RelativeToBottom(CGFloat), #No arrow
    PointingUpAt(CGRect),
    PointingDownAt(CGRect)
}
```
`blurredBackground`: `Bool` - Whether or not the background should be obscured

`nextItemAutomaticallyShows`: `Bool` - Whether or not the next onboarding item should show after the user hit the next button.

`leftButtonTitle`: `String` - Custom title for the later button

`rightButtonTitle`: `String` - Custom title for the next button

`image`: `UIImage` - Image that shows at the top of the onboarding item

`textAlign`: `NSTextAlignment` - Text alignment for the main label

###5
Once you set your onboarding items, all you have to do is show them on the screen! Just call `self.startOnboarding()` and the onboarding will start.

#Customization
You can customize color, font, timing, and where the onboarding items show through the `ABOnboardingSettings` struct.
```swift 
    //Background and text
    public static var OnboardingBackground = UIColor.whiteColor()
    public static var OnboardingNextButtonBackground = UIColor.whiteColor()
    public static var OnboardingText = UIColor.grayColor()
    public static var OnboardingLaterText = UIColor.grayColor()
    public static var BackgroundWhileOnboarding = UIColor.blackColor().colorWithAlphaComponent(0.85)
    public static var Font = UIFont.systemFontOfSize(16)
    
    //Rounded button
    public static var ButtonBackgroundNormal = UIColor.redColor()
    public static var ButtonBackgroundHighlighted = UIColor.clearColor()
    public static var ButtonTextNormal = UIColor.whiteColor()
    public static var ButtonTextHighlighted = UIColor.grayColor()
    public static var ButtonBorderNormal = UIColor.clearColor()
    public static var ButtonBorderHighlighted = UIColor.grayColor()
    
    public static var ViewToShowOnboarding: UIView?
    public static var AnimationDuration: NSTimeInterval = 0.5
    public static var TouchesDisabledOnUncoveredRect: Bool = true
```

#Installation

If you are using [Cocoapods](https://cocoapods.org/), add the following line to your Podfile:

`pod 'ABOnboarding'`

And in any of the classes that you want to show onboarding in, add this import statement:

`import ABOnboarding`

#Example
There is a short example app in this repo.

#Credits
`ABOnboarding` is brought to you by [Adam Boyd](http://adamjboyd.com/) and was originally built for use in [Treasure](http://www.treasureapp.com) and [Under 100](http://www.theunder100.com/).
