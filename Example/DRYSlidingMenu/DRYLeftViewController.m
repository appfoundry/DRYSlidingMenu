//
//  Created by Michael Seghers on 31/07/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "DRYLeftViewController.h"
#import "DRYMainViewController.h"

#define MAS_SHORTHAND
#import <Masonry/Masonry.h>
#import <DRYSlidingMenu/UIViewController+DRYSlidingMenuViewController.h>
#import <DRYSlidingMenu/DRYSlidingMenuViewController.h>

@interface DRYLeftViewController ()

@end

@implementation DRYLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"TAP" forState:UIControlStateNormal];
    [self.view addSubview:button];

    [button makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];

    [button addTarget:self action:@selector(_tapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_tapped {
    [self.drySlidingMenuViewController closeLeftSlider];

    UINavigationController *navigationController = [[UINavigationController alloc] init];
    DRYMainViewController *mainViewController = [[DRYMainViewController alloc] init];
    [navigationController setViewControllers:@[mainViewController]];
    self.drySlidingMenuViewController.mainViewController = navigationController;

}

@end
