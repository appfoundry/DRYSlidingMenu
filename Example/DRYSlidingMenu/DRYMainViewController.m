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
    CGFloat hue = ( arc4random() % 256 / 256.0f );
    CGFloat saturation = ( arc4random() % 128 / 256.0f ) + 0.5f;
    CGFloat brightness = ( arc4random() % 128 / 256.0f ) + 0.5f;
    self.view.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    self.title = [NSString stringWithFormat:@"H %f S %f B %f", hue, saturation, brightness];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapped)];
    [self.view addGestureRecognizer:tgr];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(_openLeftMenu:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(_openRightMenu:)];
}

- (IBAction)_tapped {
    UIColor *current = self.view.backgroundColor;
    self.view.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.4 animations:^{
        self.view.backgroundColor = current;
    }];
}

- (IBAction)_openLeftMenu:(id)sender {
    [self.drySlidingMenuViewController openLeftSlider];
}

- (IBAction)_openRightMenu:(id)sender {
    [self.drySlidingMenuViewController openRightSlider];
}

@end
