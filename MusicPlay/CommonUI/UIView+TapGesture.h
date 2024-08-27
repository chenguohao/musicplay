//
//  UIView+TapGesture.h
//  MusicPlay
//
//  Created by Chen guohao on 8/24/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TapGestureBlock)(void);

@interface UIView (TapGesture)

- (void)addTapGestureWithBlock:(TapGestureBlock)block;

@end

NS_ASSUME_NONNULL_END
