//
//  QKNaviPushTransition.m
//  QKNavigationController
//
//  Created by qkzhu on 26/1/19.
//  Copyright © 2019 qkzhu. All rights reserved.
//

#import "QKNaviPushTransition.h"

@implementation QKNaviPushTransition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!toViewController)
    {
        [transitionContext completeTransition:NO];
        return;
    }
    
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    // body part transitioning
    UIView *fromView;
    UIView *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    // init frame for `fromView` and `toView`
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = CGRectMake(toView.frame.size.width, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    [containerView addSubview:toView];
    
    /* add shadow to destination view */
    //toView.layer.masksToBounds = NO;
    toView.layer.shadowOffset = CGSizeMake(-4, 0);
    toView.layer.shadowRadius = 10;
    toView.layer.shadowOpacity = 0.5;
    toView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.transform = CGAffineTransformTranslate(fromView.transform, -(fromView.frame.size.width/2), 0);
        toView.transform = CGAffineTransformTranslate(toView.transform, -(toView.frame.size.width), 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
