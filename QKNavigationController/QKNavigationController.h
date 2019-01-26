//
//  QKNavigationController.h
//  QKNavigationController
//
//  Created by qkzhu on 26/1/19.
//  Copyright © 2019 qkzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QKNavigationControllerDelegate <NSObject>

@optional
- (nullable __kindof UIViewController *)prepareViewControllerToPush;

@end


/**
 A navigation controller that allows left swipe to push.
 
 Suggest to push a view controller that does NOT have horizontal scroll behaviour.
 */
@interface QKNavigationController : UINavigationController <UINavigationControllerDelegate>


@property (nonatomic, weak) id<QKNavigationControllerDelegate> qkNaviDelegate;


/**
 A boundary value to determin whether the transcation should be completed or cancelled.
 
 The value should be between 0 and 1, excluesive 0 and 1.
 If outside this range, default value (0.33) will be applied.
 */
@property (nonatomic, assign) CGFloat cancelTransciationPosition;

@end

NS_ASSUME_NONNULL_END
