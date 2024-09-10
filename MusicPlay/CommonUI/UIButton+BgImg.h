//
//  UIButton+BgImg.h
//  MusicPlay
//
//  Created by Chen guohao on 9/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BgImg)
- (void)setBackgroundColorImage:(UIColor *)color
                       forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
