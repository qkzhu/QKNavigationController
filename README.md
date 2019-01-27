# QKNavigationController
A navigation controller that allows left swipe to push.

[![CI Status](https://img.shields.io/travis/lastencent@gmail.com/QKNavigationController.svg?style=flat)](https://travis-ci.org/lastencent@gmail.com/QKNavigationController)
[![Version](https://img.shields.io/cocoapods/v/QKNavigationController.svg?style=flat)](https://cocoapods.org/pods/QKNavigationController)
[![License](https://img.shields.io/cocoapods/l/QKNavigationController.svg?style=flat)](https://cocoapods.org/pods/QKNavigationController)
[![Platform](https://img.shields.io/cocoapods/p/QKNavigationController.svg?style=flat)](https://cocoapods.org/pods/QKNavigationController)

## Preview
![Image](https://github.com/qkzhu/QKNavigationController/blob/master/demo.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

QKNavigationController is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'QKNavigationController'
```

## How to use
### step 1:
Use replace `UINavigationController` with `QKNavigationController`

### Step 2:
Make your `ViewController` conform protocol  `QKNavigationControllerDelegate`, there is one function that tells what instance of `UIViewController` you want to push when user left swipe.

### `QKNavigationControllerDelegate` is optional:
Feel free to ignore the delegate or return `nil`, `QKNavigationController` will handle it.

## Discussion
There a some libraries that I provide similar feature, such as:
* [JTNavigationController](https://github.com/ikanam/JTNavigationController)
* [JPNavigationController](https://github.com/newyjp/JPNavigationController)

The problem for me to use these libraries is, `JPNavigationController` is complicated, too much features that I don't use.
For `JTNavigationController`, it swizzing the `UIViewController`, which make me has no option if I don't need extra properties.
For both libraries, I need use 1 `XXNavigationController` and 2 `XXViewController` to achive it, somehow I feel not convinient.

`QKNavigationController` is minimize the change to original class and steps to configure, but has the same feature.

## Author

[zhu](https://github.com/qkzhu)

## License

QKNavigationController is available under the MIT license. See the LICENSE file for more info.
