KHViewControllerHierarchy
=========================

### What does it do?
Exposes some simple methods for determing which UIViewController is currently at the 'top' of the view controller stack.

Provides an interface for showing a view that can trigger an alert view containing the current 'top' view controller's hierarchy.

![alt text](https://github.com/kenthumphries/KHViewControllerHierarchy/raw/master/SampleScreenshot.png "Sample Screenshot")

### Why?
For people working on a new code base, it provides a simple way to find out the inheritance hierarchy of the screen (UIViewController) they're staring at.

### Notes
Not to be used in release code - enable the mode only within #DEBUG or similar.

### Future Updates
- Implement UIPopoverController
- Add CocoaPods support

### Wishlist
- Indicate chosen viewController
- Allow selection of a specific view controller (ie if a container view controller has two VISIBLE child view controllers)
- Allow selection of container view controllers themselves (ie UINavigationController, UITabBarController)
- Allow selection of a view
- Show inheritance hierarchy for a given view
