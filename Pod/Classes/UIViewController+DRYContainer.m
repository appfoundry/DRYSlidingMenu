//
//  Created by Michael Seghers on 14/03/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//
#import "UIViewController+DRYContainer.h"

@implementation UIViewController (DRYContainer)

- (void) dryAddSubController:(UIViewController *) controller withContainer:(UIView *) container {
    [self addChildViewController:controller];
    controller.view.frame = container.bounds;
    [container addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void) dryRemoveSubController:(UIViewController *) controller {
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

@end
