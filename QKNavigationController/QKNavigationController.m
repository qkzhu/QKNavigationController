//
//  QKNavigationController.m
//  QKNavigationController
//
//  Created by qkzhu on 26/1/19.
//  Copyright © 2019 qkzhu. All rights reserved.
//

#import "QKNavigationController.h"
#import <objc/runtime.h>
#import "QKNaviPushTransition.h"

static const void* QKPrivateKVOContext;
static const CGFloat kQKCancelTranscationPosition = 0.33;


@interface QKNavigationController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) BOOL isPushing;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePushTransition;
@property (nonatomic, strong) QKNaviPushTransition *pushTransition;

@end


@implementation QKNavigationController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self addObserver:self forKeyPath:@"disappearingViewController" options:NSKeyValueObservingOptionNew context:&QKPrivateKVOContext];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    self.panGesture = nil;
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != &QKPrivateKVOContext || self.interactivePopGestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        return;
    }
    
    SEL selector = NSSelectorFromString(@"disappearingViewController");
    if ([self respondsToSelector:selector])
    {
        /**
         Below is same as: `id disVC = [self performSelector:selector];`
         Using runtime instead to get rid of the warnning message.
         */
        IMP imp = [self methodForSelector:selector];
        id (*func)(id, SEL) = (void *)imp;
        id disappearingVC = func(self, selector);
        
        // disappearingVC not nil means in the middle of transcation
        if (disappearingVC) { return; }
        
        [self updateDelegateAndPanGestureToTopVC];
    }
}


#pragma mark - override UINavigationController functions
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* popedVC =  [super popViewControllerAnimated:animated];
    [self updateDelegateAndPanGestureToTopVC];
    return popedVC;
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers
{
    [super setViewControllers:viewControllers];
    [self updateDelegateAndPanGestureToTopVC];
}


#pragma mark - private functions
- (void)backForeground
{
    if (self.view.window)
    {
        [self updateDelegateAndPanGestureToTopVC];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            CGFloat velocity = [panGesture velocityInView:self.view].x;
            if (velocity < 0)
            {
                if (self.qkNaviDelegate && [self.qkNaviDelegate respondsToSelector:@selector(prepareViewControllerToPush)])
                {
                    UIViewController *toPushVC = [self.qkNaviDelegate prepareViewControllerToPush];
                    if (toPushVC)
                    {
                        self.isPushing = YES;
                        self.delegate = self;
                        [self pushViewController:toPushVC animated:YES];
                    }
                }
            } else {
                self.isPushing = NO;
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat progress = fabs([panGesture translationInView:self.view].x / self.view.bounds.size.width);
            progress = MIN(1.0, MAX(0.0, progress));
            if (self.isPushing) { // only consider push, leave pop with system default.
                [self.interactivePushTransition updateInteractiveTransition:progress];
            }
            break;
        }
            
        default: // for cancelled, ended and failed cased
            if (self.isPushing) {
                CGFloat progress = fabs([panGesture translationInView:self.view].x / self.view.bounds.size.width);
                if (progress > self.cancelTransciationPosition) {
                    [self.interactivePushTransition finishInteractiveTransition];
                }
                else {
                    [self.interactivePushTransition cancelInteractiveTransition];
                }
                self.delegate = nil;
                self.isPushing = NO;
            }
            break;
    }
}


/**
 Update `baseNaviDelegate and tapGesture.eanbled` based on most top view controller setting from navigation stack.
 
 If top view controller conform `BaseNavigationVCDelegate`, and it provide a view controller for swipe to push,
 then pan gesture is enabled and set its view on top view controller's view.
 Otherwise, it disable pan gesture, and remove panGesture from previous view.
 */
- (void)updateDelegateAndPanGestureToTopVC
{
    UIViewController *topVC = self.visibleViewController;
    if (!topVC) { return; }
    
    if ([topVC respondsToSelector:@selector(prepareViewControllerToPush)])
    {
        UIViewController<QKNavigationControllerDelegate> *swipeToNaviVC = (UIViewController<QKNavigationControllerDelegate> *)topVC;
        self.qkNaviDelegate = swipeToNaviVC;
        
        if ([swipeToNaviVC prepareViewControllerToPush])
        {
            [swipeToNaviVC.view addGestureRecognizer:self.panGesture];
            self.panGesture.enabled = YES;
        }
        else
        {
            [self.panGesture.view removeGestureRecognizer:self.panGesture];
            self.panGesture.enabled = NO;
        }
    }
    else
    {
        self.panGesture.enabled = NO;
        self.qkNaviDelegate = nil;
    }
}


#pragma mark lazy
- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture)
    {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 1;
    }
    
    return _panGesture;
}

- (UIPercentDrivenInteractiveTransition *)interactivePushTransition
{
    if (!_interactivePushTransition)
    {
        _interactivePushTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    }
    return _interactivePushTransition;
}

- (QKNaviPushTransition *)pushTransition
{
    if (!_pushTransition)
    {
        _pushTransition = [QKNaviPushTransition new];
    }
    return _pushTransition;
}

- (CGFloat)cancelTransciationPosition
{
    if (_cancelTransciationPosition <= 0 || _cancelTransciationPosition >= 1) {
        return kQKCancelTranscationPosition;
    }
    else {
        return _cancelTransciationPosition;
    }
}


#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    return self.isPushing ? self.pushTransition : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.isPushing ? self.interactivePushTransition : nil;
}

@end
