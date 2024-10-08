//
//  MPUITheme.h
//  MusicPlay
//
//  Created by Chen guohao on 9/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN



@interface MPUITheme : NSObject
+(UIColor*)mainDark;
+(UIColor*)mainLight;
+(UIColor*)contentBg;
+(UIColor*)contentBg_semi;
+(UIColor*)contentText;
+(UIColor*)contentText_semi;
+(UIColor*)theme_white;

+ (UIFont*)font_normal:(CGFloat)size;
+ (UIFont*)font_bold:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
