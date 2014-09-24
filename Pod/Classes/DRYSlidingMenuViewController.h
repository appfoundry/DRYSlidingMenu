//
//  Created by Michael Seghers on 9/08/13.
//  Copyright (c) 2013 AppFoundry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRYSlidingMenuViewController;

@interface DRYSlidingMenuViewController : UIViewController

@property (nonatomic, strong) UIViewController *leftMenuController;
@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *rightMenuController;

@property (nonatomic, assign) CGFloat leftSliderWidth;
@property (nonatomic, assign) CGFloat rightSliderWidth;

@property (nonatomic, readonly) BOOL isLeftOpen;
@property (nonatomic, readonly) BOOL isRightOpen;

@property (nonatomic, strong) id<UIViewControllerAnimatedTransitioning> animator;

#pragma mark - Opening and closing sliders
- (void) openLeftSlider;
- (void) closeLeftSlider;
- (void) switchLeftSlider;

- (void) openRightSlider;
- (void) closeRightSlider;
- (void) switchRightSlider;

@end