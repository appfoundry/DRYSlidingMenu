//
//  Created by Michael Seghers on 14/03/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DRYContainer)

- (void) dryAddSubController:(UIViewController *) controller withContainer:(UIView *) container;
- (void) dryRemoveSubController:(UIViewController *) controller;

- (void (^)())dryStartTransitionAndPrepareCompletionFromSubController:(UIViewController *)from toSubController:(UIViewController *)to withContainer:(UIView *)container;
@end