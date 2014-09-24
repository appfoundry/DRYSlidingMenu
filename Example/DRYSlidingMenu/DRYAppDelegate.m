//
//  DRYAppDelegate.m
//  DRYSlidingMenu
//
//  Created by CocoaPods on 07/31/2014.
//  Copyright (c) 2014 Michael Seghers. All rights reserved.
//

#import "DRYAppDelegate.h"
#import <DRYSlidingMenu/DRYSlidingMenuViewController.h>

#import "DRYLeftViewController.h"
#import "DRYMainViewController.h"

@implementation DRYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup the sliding menu view controller.
    DRYSlidingMenuViewController *slidingMenuViewController = [[DRYSlidingMenuViewController alloc] init];
    slidingMenuViewController.leftMenuController = [[DRYLeftViewController alloc] init];
    slidingMenuViewController.rightMenuController = [[DRYLeftViewController alloc] init];
    slidingMenuViewController.rightSliderWidth = 50;

    
    //Setup main view controller.
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    DRYMainViewController *mainViewController = [[DRYMainViewController alloc] init];
    [navigationController setViewControllers:@[mainViewController]];
    slidingMenuViewController.mainViewController = navigationController;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = slidingMenuViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
