//
//  QKDemoVC.m
//  QKNavigationController_Example
//
//  Created by qiankun on 26/1/19.
//  Copyright © 2019 lastencent@gmail.com. All rights reserved.
//

static const NSInteger MAX_PAGE_COUNT = 5;

#import "QKDemoVC.h"
#import "QKNavigationController.h"

@interface QKDemoVC () <QKNavigationControllerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger num;

@end


@implementation QKDemoVC

#pragma mark - life cycle
- (instancetype)initWithNum:(NSInteger)num
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        [self commonInit: num];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.label.text = [NSString stringWithFormat:@"%ld", (long)self.num];
    self.view.backgroundColor = self.num % 2 == 0 ? UIColor.orangeColor : UIColor.lightGrayColor;
}


#pragma mark - lazy
- (UILabel *)label
{
    if (!_label)
    {
        _label = [[UILabel alloc] init];
        _label.translatesAutoresizingMaskIntoConstraints = false;
        _label.font = [UIFont systemFontOfSize:80];
        _label.textColor = UIColor.whiteColor;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}


#pragma mark - helper
- (void)commonInit:(NSInteger)num
{
    self.num = num;
    
    // add lable with edge to edge constraints
    [self.view addSubview:self.label];
    // top
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view attribute:NSLayoutAttributeTopMargin
                                                          multiplier:1 constant:0];
    // bottom
    NSLayoutConstraint *bot = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view attribute:NSLayoutAttributeBottom
                                                          multiplier:1 constant:0];
    // leading
    NSLayoutConstraint *lea = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeLeading
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view attribute:NSLayoutAttributeLeading
                                                          multiplier:1 constant:0];
    // trailing
    NSLayoutConstraint *tra = [NSLayoutConstraint constraintWithItem:self.label attribute:NSLayoutAttributeTrailing
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view attribute:NSLayoutAttributeTrailing
                                                          multiplier:1 constant:0];
    [self.view addConstraints:@[top, bot, lea, tra]];
}


#pragma mark - QKNavigationControllerDelegate
- (UIViewController *)prepareViewControllerToPush
{
    NSInteger next = self.num + 1;
    return next > MAX_PAGE_COUNT ? nil : [[QKDemoVC alloc] initWithNum:next];
}


@end
