//
//  UIButton+BgImg.m
//  MusicPlay
//
//  Created by Chen guohao on 9/9/24.
//

#import "UIButton+BgImg.h"

@implementation UIButton (BgImg)

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)setBackgroundColorImage:(UIColor *)color
                       forState:(UIControlState)state {
    UIImage *image = [self imageWithColor:color];
    [self setBackgroundImage:image forState:state];

}
@end
