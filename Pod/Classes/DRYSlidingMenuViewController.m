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

@interface DRYSlidingMenuInteractionContext : NSObject <UIViewControllerContextTransitioning>
- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController completion:(void(^)(BOOL finished)) completionBlock;
@end

@interface DRYSlidingMenuDefaultMainViewAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@end

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
    _animator = [[DRYSlidingMenuDefaultMainViewAnimator alloc] init];
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
        [self _layoutViewsForLeftOpen];
    } else if (CGRectGetMaxX(_leftContainerView.frame) < 0)   {
        [self _layoutViewsForLeftClose];
    }
}

- (void) _moveRightSliderWithX:(CGFloat) x {
    _rightContainerView.center = CGPointMake(_rightContainerView.center.x + x, _rightContainerView.center.y);
    if (CGRectGetMaxX(_rightContainerView.frame) < CGRectGetMaxX(self.view.bounds)) {
        [self _layoutViewsForRightOpen];
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
    if (!_panningLeftSlider && !_panningRightSlider) {
        if (_isLeftOpen) {
            [self _layoutViewsForLeftOpen];
        } else {
            [self _layoutViewsForLeftClose];
        }
        if (_isRightOpen) {
            [self _layoutViewsForRightOpen];
        } else {
            [self _layoutViewsForRightClose];
        }
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

        _isLeftOpen = YES;
        _leftContainerView.shouldCaptureAllHits = YES;
        [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
            [self _layoutViewsForLeftOpen];
        }];
    }
}

- (void) closeLeftSlider {
    _isLeftOpen = NO;
    _leftContainerView.shouldCaptureAllHits = NO;
    [_leftContainerView endEditing:YES];
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        [self _layoutViewsForLeftClose];
    }];
}

- (void) _layoutViewsForLeftOpen {
    _leftContainerView.frame = CGRectMake(0, 0, _leftSliderWidth, self.view.bounds.size.height);
    _mainContainerView.frame = CGRectMake(_leftSliderWidth, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
}

- (void) _layoutViewsForLeftClose {
    _leftContainerView.frame = CGRectMake(-_leftSliderWidth, 0, _leftSliderWidth, self.view.bounds.size.height);
    _mainContainerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
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

        _isRightOpen = YES;
        _rightContainerView.shouldCaptureAllHits = YES;
        [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
            [self _layoutViewsForRightOpen];
        }];
    }
}

- (void) closeRightSlider {
    _isRightOpen = NO;
    _rightContainerView.shouldCaptureAllHits = NO;
    [_rightContainerView endEditing:YES];
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
        [self _layoutViewsForRightClose];
    }];
}

- (void) switchRightSlider {
    if (_isRightOpen) {
        [self closeRightSlider];
    } else {
        [self openRightSlider];
    }
}

- (void) _layoutViewsForRightOpen {
    _rightContainerView.frame = CGRectMake(self.view.bounds.size.width - _rightSliderWidth, 0, _rightSliderWidth, self.view.bounds.size.height);
}

- (void) _layoutViewsForRightClose {
    _rightContainerView.frame = CGRectMake(self.view.bounds.size.width, 0, _rightSliderWidth, self.view.bounds.size.height);
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
        if (_mainViewController) {
            void (^done)() = [self dryStartTransitionAndPrepareCompletionFromSubController:_mainViewController toSubController:mainViewController withContainer:_mainContainerView];
            DRYSlidingMenuInteractionContext *context = [[DRYSlidingMenuInteractionContext alloc] initWithFromViewController:_mainViewController toViewController:mainViewController completion:^(BOOL finished) {
                done();
                _mainViewController = mainViewController;
            }];
            [_animator animateTransition:context];
        } else {
            [self dryAddSubController:mainViewController withContainer:_mainContainerView];
            _mainViewController = mainViewController;
        }
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

- (NSUInteger) supportedInterfaceOrientations {
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

@implementation DRYSlidingMenuInteractionContext {
    NSDictionary *_viewcontrollers;
    __weak UIView *_containerView;
    void(^_completionBlock)(BOOL);
}


- (instancetype) initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController completion:(void(^)(BOOL finished)) completionBlock {
    self = [super init];
    if (self) {
        _viewcontrollers = @{
                UITransitionContextFromViewControllerKey:fromViewController,
                UITransitionContextToViewControllerKey:toViewController
        };
        _containerView = fromViewController.view.superview;
        _completionBlock = [completionBlock copy];
    }
    return self;
}

- (UIView *)containerView {
    return _containerView;
}

- (BOOL)isAnimated {
    return NO;
}

- (BOOL)isInteractive {
    return NO;
}

- (BOOL)transitionWasCancelled {
    return NO;
}

- (UIModalPresentationStyle)presentationStyle {
    return UIModalPresentationPopover;
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {

}

- (void)finishInteractiveTransition {

}

- (void)cancelInteractiveTransition {

}

- (void)completeTransition:(BOOL)didComplete {
    _completionBlock(didComplete);
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return _viewcontrollers[key];
}

- (UIView *)viewForKey:(NSString *)key {
    return [_viewcontrollers[key] view];
}

- (CGAffineTransform)targetTransform {
    return CGAffineTransformIdentity;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    return  self.containerView.bounds;
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    return  self.containerView.bounds;
}

@end

@implementation DRYSlidingMenuDefaultMainViewAnimator {

}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return .75;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    to.view.alpha = 0;
    from.view.alpha = 1;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        from.view.alpha = 0;
        to.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}


@end
