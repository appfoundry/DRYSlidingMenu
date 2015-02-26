//
//  Created by Michael Seghers on 9/08/13.
//  Copyright (c) 2013 AppFoundry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DRYSlidingMenuViewController;

@protocol DRYSlidingMenuViewControllerDelegate <NSObject>

@optional
- (void)slidingMenuViewControllerWillOpenLeftMenu:(DRYSlidingMenuViewController *)controller;
- (void)slidingMenuViewControllerWillOpenRightMenu:(DRYSlidingMenuViewController *)controller;

- (void)slidingMenuViewControllerDidOpenLeftMenu:(DRYSlidingMenuViewController *)controller;
- (void)slidingMenuViewControllerDidOpenRightMenu:(DRYSlidingMenuViewController *)controller;

- (void)slidingMenuViewControllerWillCloseLeftMenu:(DRYSlidingMenuViewController *)controller;
- (void)slidingMenuViewControllerWillCloseRightMenu:(DRYSlidingMenuViewController *)controller;

- (void)slidingMenuViewControllerDidCloseLeftMenu:(DRYSlidingMenuViewController *)controller;
- (void)slidingMenuViewControllerDidCloseRightMenu:(DRYSlidingMenuViewController *)controller;

@end

@interface DRYSlidingMenuViewController : UIViewController

@property (nonatomic, weak) id<DRYSlidingMenuViewControllerDelegate> delegate;

@property (nonatomic, strong) UIViewController *leftMenuController;
@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UIViewController *rightMenuController;

@property (nonatomic, assign) CGFloat leftSliderWidth;
@property (nonatomic, assign) CGFloat rightSliderWidth;

@property (nonatomic, readonly) BOOL isLeftOpen;
@property (nonatomic, readonly) BOOL isRightOpen;

#pragma mark - Opening and closing sliders
- (void) openLeftSlider;
- (void) closeLeftSlider;
- (void) switchLeftSlider;

- (void) openRightSlider;
- (void) closeRightSlider;
- (void) switchRightSlider;

@end