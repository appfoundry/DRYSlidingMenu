//
//  Created by Michael Seghers on 10/08/13.
//  Copyright (c) 2013 AppFoundry. All rights reserved.
//

#import "DRYAllHitCapturingView.h"

@implementation DRYAllHitCapturingView

- (BOOL) pointInside:(CGPoint) point withEvent:(UIEvent *) event {
    BOOL result;
    if (_shouldCaptureAllHits) {
        result = YES;
    } else {
        result = [super pointInside:point withEvent:event];
    }
    return result;
}

@end
