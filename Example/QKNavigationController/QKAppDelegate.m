//
//  QKAppDelegate.m
//  QKNavigationController
//
//  Created by lastencent@gmail.com on 01/26/2019.
//  Copyright (c) 2019 lastencent@gmail.com. All rights reserved.
//

#import "QKAppDelegate.h"
#import "QKNavigationController.h"
#import "QKDemoVC.h"

@interface QKAppDelegate ()

@property (nonatomic, strong) QKNavigationController *rootVC;

@end


@implementation QKAppDelegate

#pragma mark - life cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    QKDemoVC *startingVC = [[QKDemoVC alloc] initWithNum:0];
    self.rootVC.viewControllers = @[startingVC];
    self.window.rootViewController = self.rootVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - lazy
- (UIWindow *)window
{
    if (!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    return _window;
}

- (QKNavigationController *)rootVC
{
    if (!_rootVC)
    {
        _rootVC = [[QKNavigationController alloc] init];
    }
    
    return _rootVC;
}

@end
