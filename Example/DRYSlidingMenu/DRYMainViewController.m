//
//  Created by Michael Seghers on 31/07/14.
//  Copyright (c) 2014 AppFoundry. All rights reserved.
//

#import "DRYMainViewController.h"
#import <DRYSlidingMenu/DRYSlidingMenuViewController.h>
#import <DRYSlidingMenu/UIViewController+DRYSlidingMenuViewController.h>

@interface DRYMainViewController ()

@end

@implementation DRYMainViewController

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

    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapped)];
    [self.view addGestureRecognizer:tgr];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(_openLeftMenu:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(_openRightMenu:)];
}

- (IBAction)_tapped {
    self.view.backgroundColor = [UIColor blueColor];
    [UIView animateWithDuration:0.4 animations:^{
        self.view.backgroundColor = [UIColor whiteColor];
    }];
}

- (IBAction)_openLeftMenu:(id)sender {
    [self.drySlidingMenuViewController openLeftSlider];
}

- (IBAction)_openRightMenu:(id)sender {
    [self.drySlidingMenuViewController openRightSlider];
}


@end
