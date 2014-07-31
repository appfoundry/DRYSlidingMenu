//
//  Created by Michael Seghers on 14/03/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "UIViewController+DRYSlidingMenu.h"
#import "DRYSlidingMenuViewController.h"

@implementation UIViewController (DRYSlidingMenu)

- (DRYSlidingMenuViewController *)drySlidingMenuViewController {
	if([self.parentViewController isKindOfClass:DRYSlidingMenuViewController.class]){
		return (DRYSlidingMenuViewController *)self.parentViewController;
	} else {
		return [self.parentViewController drySlidingMenuViewController];
	}
}


@end
