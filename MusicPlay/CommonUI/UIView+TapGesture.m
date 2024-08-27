#import "UIView+TapGesture.h"
#import <objc/runtime.h>

static const void *TapGestureBlockKey = &TapGestureBlockKey;

@implementation UIView (TapGesture)

- (void)addTapGestureWithBlock:(TapGestureBlock)block {
    // Remove any existing tap gestures
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:recognizer];
        }
    }

    // Create a new tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    // Store the block using associated objects
    objc_setAssociatedObject(self, TapGestureBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    TapGestureBlock block = objc_getAssociatedObject(self, TapGestureBlockKey);
    if (block) {
        block();
    }
}

@end
