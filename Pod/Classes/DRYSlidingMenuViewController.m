//
//  Created by Michael Seghers on 9/08/13.
//  Copyright (c) 2013 AppFoundry. All rights reserved.
//

#import "DRYSlidingMenuViewController.h"
#import "DRYAllHitCapturingView.h"
#import "UIViewController+DRYContainer.h"

@interface DRYSlidingMenuViewController () <UIGestureRecognizerDelegate> {
    UIView *_mainContainerView;
    DRYAllHitCapturingView *_leftContainerView;
    DRYAllHitCapturingView *_rightContainerView;
    UIPanGestureRecognizer *_panGestureRecognizer;
    
    CGFloat _lastXMovement;
    BOOL _panningLeftSlider;
    BOOL _panningRightSlider;
}

@end

#define DEFAULT_SLIDER_WIDTH 240.0F
#define DEFAULT_ANIMATION_DURATION 0.25F

@implementation DRYSlidingMenuViewController

- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self _init];
    }
    return self;
}

- (void)awakeFromNib {
    [self _init];
}

- (void) _init {
    _leftSliderWidth = DEFAULT_SLIDER_WIDTH;
    _rightSliderWidth = DEFAULT_SLIDER_WIDTH;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self _setupPanGestureRecognizer];
    [self _setupMainContainerView];
    [self _setupLeftContainerView];
    [self _setupRightContainerView];
}

- (void) _setupPanGestureRecognizer {
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePanGesture:)];
    _panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panGestureRecognizer];
}

- (void) _handlePanGesture:(UIPanGestureRecognizer *) r {
    if (r.state == UIGestureRecognizerStateChanged) {
        [self _handleOngoingPanGesture:r];
    } else if (r.state == UIGestureRecognizerStateEnded) {
        [self _handleEndOfPanGestureWithXMovement];
    }
}

- (void)_handleOngoingPanGesture:(UIPanGestureRecognizer *)r {
    _lastXMovement = [r translationInView:self.view].x;
    if (_panningLeftSlider) {
        [self _moveLeftSliderWithX:_lastXMovement];
    } else if (_panningRightSlider) {
        [self _moveRightSliderWithX:_lastXMovement];
    }
    [r setTranslation:CGPointZero inView:self.view];
}

- (void) _moveLeftSliderWithX:(CGFloat) x {
    _leftContainerView.center = CGPointMake(_leftContainerView.center.x + x, _leftContainerView.center.y);
    _mainContainerView.center = CGPointMake(_mainContainerView.center.x + x, _mainContainerView.center.y);
    if (_leftContainerView.frame.origin.x > 0) {
        [self _layoutViewsForLeftOpenForSize:self.view.bounds.size];
    } else if (CGRectGetMaxX(_leftContainerView.frame) < 0)   {
        [self _layoutViewsForLeftCloseForSize:self.view.bounds.size];
    }
}

- (void) _moveRightSliderWithX:(CGFloat) x {
    _rightContainerView.center = CGPointMake(_rightContainerView.center.x + x, _rightContainerView.center.y);
    if (CGRectGetMaxX(_rightContainerView.frame) < CGRectGetMaxX(self.view.bounds)) {
        [self _layoutViewsForRightOpenForSize:self.view.bounds.size];
    }
}

- (void)_handleEndOfPanGestureWithXMovement {
    if ([self _movementWasLeft:_lastXMovement]) {
        if (_panningRightSlider) {
            [self openRightSlider];
        } else if (_panningLeftSlider) {
            [self closeLeftSlider];
        }
    } else {
        if (_panningRightSlider) {
            [self closeRightSlider];
        } else {
            [self openLeftSlider];
        }
    }
    _panningLeftSlider = NO;
    _panningRightSlider = NO;
}

- (BOOL) _movementWasLeft:(CGFloat) xMovement {
    return xMovement < 0;
}

- (BOOL) _movementWasRight:(CGFloat) xMovement {
    return xMovement > 0;
}

- (void) _setupMainContainerView {
    _mainContainerView = [[UIView alloc] init];
    [self.view addSubview:_mainContainerView];
    
    if (_mainViewController) {
        [_mainContainerView addSubview:_mainViewController.view];
    }
}

- (void) _setupLeftContainerView {
    _leftContainerView = [[DRYAllHitCapturingView alloc] init];
    [self _setupTapTapGestureRecognizerForView:_leftContainerView withAction:@selector(closeLeftSlider)];
    [self.view addSubview:_leftContainerView];
    
    if (_leftMenuController) {
        [_leftContainerView addSubview:_leftMenuController.view];
    }
}

- (void) _setupRightContainerView {
    _rightContainerView = [[DRYAllHitCapturingView alloc] init];
    [self _setupTapTapGestureRecognizerForView:_rightContainerView withAction:@selector(closeRightSlider)];
    [self.view addSubview:_rightContainerView];
    
    if (_rightMenuController) {
        [_rightContainerView addSubview:_rightMenuController.view];
    }
}

- (void) _setupTapTapGestureRecognizerForView:(UIView *) view withAction:(SEL) action {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    tapRecognizer.delegate = self;
    tapRecognizer.cancelsTouchesInView = NO;
    [view addGestureRecognizer:tapRecognizer];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (!_panningLeftSlider && !_panningRightSlider) {
        [self _adjustFramesToSize:self.view.bounds.size];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self _adjustFramesToSize:size];
}

- (void)_adjustFramesToSize:(CGSize)size {
    
        if (_isLeftOpen) {
            [self _layoutViewsForLeftOpenForSize:size];
        } else {
            [self _layoutViewsForLeftCloseForSize:size];
        }
        if (_isRightOpen) {
            [self _layoutViewsForRightOpenForSize:size];
        } else {
            [self _layoutViewsForRightCloseForSize:size];
        }
}

#pragma mark - Managing dimensions
- (void) setLeftSliderWidth:(CGFloat) leftSliderWidth {
    if (_leftSliderWidth != leftSliderWidth) {
        _leftSliderWidth = leftSliderWidth;
        [self.view setNeedsLayout];
    }
}

- (void) setRightSliderWidth:(CGFloat) rightSliderWidth {
    if (_rightSliderWidth != rightSliderWidth) {
        _rightSliderWidth = rightSliderWidth;
        [self.view setNeedsLayout];
    }
}

#pragma mark - Opening and closing sliders
- (void) openLeftSlider {
    if (_leftMenuController) {
        if (_isRightOpen) {
            [self closeRightSlider];
        }

        if ([self.delegate respondsToSelector:@selector(slidingMenuViewControllerWillOpenLeftMenu:)]) {
            [self.delegate slidingMenuViewControllerWillOpenLeftMenu:self];
        }
        _isLeftOpen = YES;
        _leftContainerView.shouldCaptureAllHits = YES;
        [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
            [self _layoutViewsForLeftOpenForSize:self.view.bounds.size];
        } completion:^(BOOL finished) {
            if (finished && [self.delegate respondsToSelector:@selector(slidingMenuViewControllerDidOpenLeftMenu:)]) {
                [self.delegate slidingMenuViewControllerDidOpenLeftMenu:self];
            }
        }];
    }
}

- (void) closeLeftSlider {
    if ([self.delegate respondsToSelector:@selector(slidingMenuViewControllerWillCloseLeftMenu:)]) {
        [self.delegate slidingMenuViewControllerWillCloseLeftMenu:self];
    }

    _isLeftOpen = NO;
    _leftContainerView.shouldCaptureAllHits = NO;
    [_leftContainerView endEditing:YES];
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        [self _layoutViewsForLeftCloseForSize:self.view.bounds.size];
    } completion:^(BOOL finished) {
        if (finished && [self.delegate respondsToSelector:@selector(slidingMenuViewControllerDidCloseLeftMenu:)]) {
            [self.delegate slidingMenuViewControllerDidCloseLeftMenu:self];
        }
    }];
}

- (void) _layoutViewsForLeftOpenForSize:(CGSize)size {
    _leftContainerView.frame = CGRectMake(0, 0, _leftSliderWidth, size.height);
    _mainContainerView.frame = CGRectMake(_leftSliderWidth, 0, size.width, size.height);
}

- (void) _layoutViewsForLeftCloseForSize:(CGSize)size {
    _leftContainerView.frame = CGRectMake(-_leftSliderWidth, 0, _leftSliderWidth, size.height);
    _mainContainerView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void) switchLeftSlider {
    if (_isLeftOpen) {
        [self closeLeftSlider];
    } else {
        [self openLeftSlider];
    }
}

- (void) openRightSlider {
    if (_rightMenuController) {
        if (_isLeftOpen) {
            [self closeLeftSlider];
        }
        if ([self.delegate respondsToSelector:@selector(slidingMenuViewControllerWillOpenRightMenu:)]) {
            [self.delegate slidingMenuViewControllerWillOpenRightMenu:self];
        }


        _isRightOpen = YES;
        _rightContainerView.shouldCaptureAllHits = YES;
        [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
            [self _layoutViewsForRightOpenForSize:self.view.bounds.size];
        } completion:^(BOOL finished) {
            if (finished && [self.delegate respondsToSelector:@selector(slidingMenuViewControllerDidOpenRightMenu:)]) {
                [self.delegate slidingMenuViewControllerDidOpenRightMenu:self];
            }
        }];
    }
}

- (void) closeRightSlider {
    if ([self.delegate respondsToSelector:@selector(slidingMenuViewControllerWillCloseRightMenu:)]) {
        [self.delegate slidingMenuViewControllerWillCloseRightMenu:self];
    }

    _isRightOpen = NO;
    _rightContainerView.shouldCaptureAllHits = NO;
    [_rightContainerView endEditing:YES];
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        [self _layoutViewsForRightCloseForSize:self.view.bounds.size];
    } completion:^(BOOL finished) {
        if (finished && [self.delegate respondsToSelector:@selector(slidingMenuViewControllerDidCloseRightMenu:)]) {
            [self.delegate slidingMenuViewControllerDidCloseRightMenu:self];
        }
    }];
}

- (void) switchRightSlider {
    if (_isRightOpen) {
        [self closeRightSlider];
    } else {
        [self openRightSlider];
    }
}

- (void) _layoutViewsForRightOpenForSize:(CGSize)size {
    _rightContainerView.frame = CGRectMake(size.width - _rightSliderWidth, 0, _rightSliderWidth, size.height);
}

- (void) _layoutViewsForRightCloseForSize:(CGSize)size {
    _rightContainerView.frame = CGRectMake(size.width, 0, _rightSliderWidth, size.height);
}

#pragma mark - Child controller management
- (void) setLeftMenuController:(UIViewController *) leftMenuController {
    if (_leftMenuController != leftMenuController) {
        [self dryRemoveSubController:_leftMenuController];
        _leftMenuController = leftMenuController;
        [self dryAddSubController:leftMenuController withContainer:_leftContainerView];
    }
}

- (void) setMainViewController:(UIViewController *) mainViewController {
    if (_mainViewController != mainViewController) {
        [self dryRemoveSubController:_mainViewController];
        _mainViewController = mainViewController;
        [self dryAddSubController:mainViewController withContainer:_mainContainerView];
    }
}

- (void) setRightMenuController:(UIViewController *) rightMenuController {
    if (_rightMenuController != rightMenuController) {
        [self dryRemoveSubController:_rightMenuController];
        _rightMenuController = rightMenuController;
        [self dryAddSubController:rightMenuController withContainer:_rightContainerView];
    }
}

#pragma mark - Tap and pan gesture recognizer delegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer *) gestureRecognizer shouldReceiveTouch:(UITouch *) touch {
    BOOL result;
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (_isLeftOpen) {
            CGPoint location = [touch locationInView:_leftContainerView];
            result = !CGRectContainsPoint(_leftContainerView.bounds, location);
        } else {
            CGPoint location = [touch locationInView:_rightContainerView];
            result = !CGRectContainsPoint(_rightContainerView.bounds, location);
        }
    } else {
        result = (_isLeftOpen || [touch locationInView:self.view].x < 10) || (_isRightOpen || [touch locationInView:self.view].x > self.view.bounds.size.width - 10);
    }
    return result;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL result = YES;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGFloat x = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.view].x;
        BOOL wasLeft = [self _movementWasLeft:x];
        BOOL wasRight = [self _movementWasRight:x];
        
        
        if (_leftMenuController && (!_isRightOpen && ((wasLeft && _isLeftOpen) || (wasRight && !_isLeftOpen)))) {
            _panningLeftSlider = YES;
        } else if (_rightMenuController && (!_isLeftOpen && ((wasRight && _isRightOpen) || (wasLeft && !_isRightOpen)))) {
            _panningRightSlider = YES;
        }
        
        result = _panningLeftSlider || _panningRightSlider;
    }
    return result;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    _panGestureRecognizer.enabled = NO;
    [self closeLeftSlider];
    [self closeRightSlider];
    _panningLeftSlider = NO;
    _panningRightSlider = NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _panGestureRecognizer.enabled = YES;
}

@end
