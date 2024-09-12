//
//  UITextView+Link.h
//  KuKoo
//
//  Created by Chen guohao on 2/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Link)
- (void)addLinkWithString:(NSString *)string url:(NSString *)url textColor:(UIColor *)textColor font:(UIFont *)font underlineColor:(UIColor *)underlineColor;
@end

NS_ASSUME_NONNULL_END
