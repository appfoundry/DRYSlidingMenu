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

@interface DRYAppDelegate () <DRYSlidingMenuViewControllerDelegate>

@end

@implementation DRYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup the sliding menu view controller.
    DRYSlidingMenuViewController *slidingMenuViewController = [[DRYSlidingMenuViewController alloc] init];
    slidingMenuViewController.delegate = self;
    slidingMenuViewController.leftMenuController = [[DRYLeftViewController alloc] init];
    slidingMenuViewController.rightMenuController = [[DRYLeftViewController alloc] init];

    
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

- (void)slidingMenuViewControllerDidOpenLeftMenu:(DRYSlidingMenuViewController *)controller {
    NSLog(@"Left opened");
}

- (void)slidingMenuViewControllerDidOpenRightMenu:(DRYSlidingMenuViewController *)controller {
    NSLog(@"Right opened");
}

- (void)slidingMenuViewControllerDidCloseLeftMenu:(DRYSlidingMenuViewController *)controller {
    NSLog(@"Left closed");
}

- (void)slidingMenuViewControllerDidCloseRightMenu:(DRYSlidingMenuViewController *)controller {
    NSLog(@"Right closed");
}

- (void)slidingMenuViewControllerWillOpenLeftMenu:(DRYSlidingMenuViewController *)controller {
    NSLog(@"Left will open");
}

- (void)slidingMenuViewControllerWillCloseLeftMenu:(DRYSlidingMenuViewController *)controller {
    NSLog(@"Left will close");
}

- (void)slidingMenuViewControllerWillOpenRightMenu:(DRYSlidingMenuViewController *)controller {
    NSLog(@"Right will open");
}

- (void)slidingMenuViewControllerWillCloseRightMenu:(DRYSlidingMenuViewController *)controller {
    NSLog(@"Right will close");
}

@end
